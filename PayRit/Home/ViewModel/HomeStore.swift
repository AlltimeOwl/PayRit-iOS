//
//  HomeViewModel.swift
//  PayRit
//
//  Created by 임대진 on 3/2/24.
//

import SwiftUI
import PDFKit

public enum HomeSegment {
    case payrit
    case promise
}

enum SortingType: String, CodingKey, CaseIterable {
    case recent = "최근 거래 순"
    case old = "오래된 순"
    case expiration = "기간 만료 순"
}

@Observable
final class HomeStore {
    var segment: HomeSegment = .payrit
    var sortingType: SortingType = .recent
    var certificates: [Certificate] = [Certificate]()
    var certificateDetail: CertificateDetail = CertificateDetail.EmptyCertificate
    var isShowingPaymentSuccessAlert: Bool = false
    var isShowingAcceptFailAlert: Bool = false
    var isShowingAuthCompleteAlert: Bool = false
    var isHiddenInfoBox: Bool = false
    var isAddedPromise: Bool = false
    var isLoading: Bool = true
    
//    var test: [Certificate] = [Certificate(paperId: 0, paperRole: .CREDITOR, transactionDate: "2024-04-20", repaymentStartDate: "2024-04-20", repaymentEndDate: "2024-06-20", amount: 500000, paperStatus: "COMPLETE_WRITING", peerName: "정주성", dueDate: 50, repaymentRate: 40.0, isWriter: true),
//                               Certificate(paperId: 0, paperRole: .DEBTOR, transactionDate: "2024-03-10", repaymentStartDate: "2024-03-14", repaymentEndDate: "2024-05-24", amount: 2500000, paperStatus: "EXPIRED", peerName: "김성훈", dueDate: 24, repaymentRate: 10.0, isWriter: true),
//                               Certificate(paperId: 0, paperRole: .CREDITOR, transactionDate: "2024-04-20", repaymentStartDate: "2024-04-20", repaymentEndDate: "2024-08-20", amount: 500000, paperStatus: "WAITING_AGREE", peerName: "신상원", dueDate: 0, repaymentRate: 0.0, isWriter: true)]
//    
//    var certificateDetail: CertificateDetail = CertificateDetail(paperId: 0, paperUrl: "", memberRole: "CREDITOR", paperFormInfo: PaperFormInfo(primeAmount: 500000, interest: 0, amount: 500000, remainingAmount: 200000, interestRate: 0.0, interestPaymentDate: 0, repaymentStartDate: "2024-04-20", repaymentEndDate: "2024-08-20", transactionDate: "2024-04-20", specialConditions: ""), repaymentRate: 40.0, creditorProfile: Creditor(name: "임대진", phoneNumber: "010-5009-7937", address: ""), debtorProfile: Debtor(name: "정주성", phoneNumber: "010-8113-7937", address: ""), dueDate: 50, memoListResponses: [Memo](), repaymentHistories: [Deducted](), modifyRequest: "")
    
    func sortingCertificates() {
        switch sortingType {
        case .recent:
            self.certificates.sort { $0.writingDayCal > $1.writingDayCal }
        case .old:
            self.certificates.sort { $0.writingDayCal < $1.writingDayCal }
        case .expiration:
            self.certificates.sort { $0.dueDate < $1.dueDate }
        }
    }
    
    // MARK: - 차용증 불러오기
    func loadCertificates() async {
        let urlString = "https://payrit.info/api/v1/paper/list"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                if let data = data {
    //                    let responseData = String(data: data, encoding: .utf8)
                    do {
                        var certificates = try JSONDecoder().decode([Certificate].self, from: data)
                        
                        switch self.sortingType {
                        case .recent:
                            certificates.sort { $0.writingDayCal > $1.writingDayCal }
                        case .old:
                            certificates.sort { $0.writingDayCal < $1.writingDayCal }
                        case .expiration:
                            certificates.sort { $0.dueDate < $1.dueDate }
                        }
                        self.certificates = certificates
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
                self.isLoading = false
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                }
                self.isLoading = false
            }
        }
        task.resume()
    }
    
    func loadDetail(id: Int) async {
        let urlString = "https://payrit.info/api/v1/paper/\(id)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("Response data: \(responseData ?? "No data")")
                    do {
                        let certificate = try JSONDecoder().decode(CertificateDetail.self, from: data)
                        self.certificateDetail = certificate
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                }
            }
        }
        task.resume()
    }
    
    // MARK: - 차용증 수락
    @MainActor
    func acceptCertificate(paperId: Int) {
        let urlString = "https://payrit.info/api/v1/paper/approve/accept/\(paperId)"
        let pdfURL: URL = self.generatePDF()
        guard let url = URL(string: urlString) else { return }
        guard let pdfData = try? Data(contentsOf: pdfURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let boundary = UUID().uuidString
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"document.pdf\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/pdf\r\n\r\n".data(using: .utf8)!)
        body.append(pdfData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = TimeInterval(20)
        session.configuration.timeoutIntervalForResource = TimeInterval(20)
        
        let task = session.uploadTask(with: request, from: body) { _, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
                if (200..<300).contains(response.statusCode) {
                    print("PDF 파일 업로드 성공")
                    Task {
                        await self.loadCertificates()
                    }
                    self.isShowingAuthCompleteAlert.toggle()
                } else {
                    print("Unexpected status code: \(response.statusCode)")
                }
            } else {
                print("Unexpected error: No data or response")
            }
        }
        task.resume()
    }
    
    func savePaymentHistory(paperId: Int, amount: Int, impUid: String, merchantUid: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/transaction/save"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            let body = [
                "paperId": paperId,
                "transactionDate": Date().dateToFullString(),
                "amount": amount,
                "transactionType": "PAPER_TRANSACTION",
                "impUid": impUid,
                "merchantUid": merchantUid,
                "isSuccess": true
            ] as [String: Any]
            print(body)
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data, let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                print("JSON Response: \(json)")
                            }
                        } catch {
                            print("Error parsing JSON response")
                        }
                        Task {
                            await self.loadCertificates()
                        }
                        self.isShowingPaymentSuccessAlert.toggle()
                    } else {
                        self.paymentCancle(impUid: impUid, merchantUid: merchantUid)
                        self.isShowingAcceptFailAlert.toggle()
                        let responseData = String(data: data, encoding: .utf8)
                        print("\(response.statusCode) data: \(responseData ?? "No data")")
                    }
                } else {
                    print("Unexpected error: No data or response")
                }
            }
            task.resume()
        }
    }
    
    /// 차용증 수정 요청청
    func certificatePixRequest(paperId: Int, contents: String, completion: @escaping (Bool) -> Void) {
        let urlString = "https://payrit.info/api/v1/paper/modify/request"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let body = [
            "paperId": paperId,
            "contents": contents
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON data")
            completion(false)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")                
                return
            }
            if (200..<300).contains(httpResponse.statusCode) {
                print("차용증 수정 요청 성공")
                completion(true)
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                }
                completion(false)
            }
        }
        task.resume()
    }
    
    /// 차용증 결제 취소
    func paymentCancle(impUid: String, merchantUid: String) {
        var urlComponents = URLComponents()
        if let Key = Bundle.main.object(forInfoDictionaryKey: "PAYMENT_CANCEL_KEY") as? String {
            urlComponents.scheme = "https"
            urlComponents.host = "payrit.info"
            urlComponents.path = "/api/v1/transaction/dev/cancel/\(Key)"
        }
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            let body = [
                "impUid": impUid,
                "merchantUid": merchantUid,
                "reason": "결제 내역 저장 실패"
            ] as [String: Any]
            print(body)
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data, let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
//                        do {
//                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                                print("JSON Response: \(json)")
//                            }
//                        } catch {
//                            print("Error parsing JSON response")
//                        }
//                        Task {
//                            await self.loadCertificates()
//                        }
                    } else {
                        let responseData = String(data: data, encoding: .utf8)
                        print("\(response.statusCode) data: \(responseData ?? "No data")")
                    }
                } else {
                    print("Unexpected error: No data or response")
                }
            }
            task.resume()
        }
    }
    
    /// 차용증 숨김
    func certificateHide(id: Int, completion: @escaping (Bool) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/paper/hide/\(id)"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion(false)
                } else if let data = data, let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
                        print("숨김 완료")
                        completion(true)
                    } else {
                        let responseData = String(data: data, encoding: .utf8)
                        print("\(response.statusCode) data: \(responseData ?? "No data")")
                        completion(false)
                    }
                } else {
                    print("Unexpected error: No data or response")
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    func certificateRefuse(id: Int, completion: @escaping (Bool) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/paper/refuse/\(id)"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion(false)
                } else if let data = data, let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
                        print("거절 완료")
                        completion(true)
                    } else {
                        let responseData = String(data: data, encoding: .utf8)
                        print("\(response.statusCode) data: \(responseData ?? "No data")")
                        completion(false)
                    }
                } else {
                    print("Unexpected error: No data or response")
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    // MARK: - 메모
    func loadMemo(id: Int, completion: @escaping ([Memo]?, Error?) -> Void) {
        let urlString = "https://payrit.info/api/v1/memo/\(id)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                if let data = data {
                    do {
                        let memo = try JSONDecoder().decode([Memo].self, from: data)
                        completion(memo, nil)
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(nil, error)
                    }
                }
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                completion(nil, nil)
            }
        }
        task.resume()
    }

    func memoSave(paperId: Int, content: String, completion: @escaping ([Memo]?, Error?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/memo/\(paperId)"
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            
            let body = [
                "content": content
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    completion(nil, error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    completion(nil, nil)
                    return
                }
                
                if (200..<300).contains(httpResponse.statusCode) {
                    print("Response status code: \(httpResponse.statusCode)")
                    self.loadMemo(id: paperId) { (memoArray, error) in
                        if let error = error {
                            print("Error occurred: \(error)")
                            completion(nil, error)
                        } else if let memoArray = memoArray {
                            completion(memoArray, nil)
                        }
                    }
                } else {
                    print("Unexpected status code: \(httpResponse.statusCode)")
                    completion(nil, nil)
                }
            }
            task.resume()
        }
    }

    func memoDelete(paperId: Int, memoId: Int, completion: @escaping ([Memo]?, Error?) -> Void) {
        let urlString = "https://payrit.info/api/v1/memo/\(memoId)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (_, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(nil, nil)
                return
            }
            if (200..<300).contains(httpResponse.statusCode) {
                print("메모 삭제 성공")
                self.loadMemo(id: paperId) { (memoArray, error) in
                    if let error = error {
                        print("Error occurred: \(error)")
                        completion(nil, error)
                    } else if let memoArray = memoArray {
                        completion(memoArray, nil)
                    }
                }
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    // MARK: - 상환
    func deductedSave(paperId: Int, repaymentDate: String, repaymentAmount: String, completion: @escaping ([Deducted]?, Error?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/paper/repayment/request"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            let body = [
                "paperId": paperId,
                "repaymentDate": repaymentDate,
                "repaymentAmount": repaymentAmount
            ] as [String: Any]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
            }
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
                        print("상환 내역 작성 성공")
                        self.loadDeduceted(paperId: paperId) { (array, error) in
                            if let error = error {
                                print("Error occurred: \(error)")
                                completion(nil, error)
                            } else if let deducted = array {
                                completion(deducted, nil)
                            }
                        }
                    } else {
                        print("Unexpected status code: \(response.statusCode)")
                    }
                } else {
                    print("Unexpected error: No data or response")
                }
            }
            task.resume()
        }
    }
    
    func loadDeduceted(paperId: Int, completion: @escaping ([Deducted]?, Error?) -> Void) {
        let urlString = "https://payrit.info/api/v1/paper/\(paperId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                if let data = data {
                    do {
                        let detail = try JSONDecoder().decode(CertificateDetail.self, from: data)
                        completion(detail.repaymentHistories, nil)
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(nil, error)
                    }
                }
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    func deductedDelete(paperId: Int, historyId: Int, completion: @escaping ([Deducted]?, Error?) -> Void) {
        let urlString = "https://payrit.info/api/v1/paper/repayment/cancel"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let body = [
            "paperId": paperId,
            "historyId": historyId
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON data")
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(nil, nil)
                return
            }
            if (200..<300).contains(httpResponse.statusCode) {
                print("상환 내역 삭제 성공")
                self.loadDeduceted(paperId: paperId) { (array, error) in
                    if let error = error {
                        print("Error occurred: \(error)")
                        completion(nil, error)
                    } else if let deducted = array {
                        completion(deducted, nil)
                    }
                }
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                }
                completion(nil, nil)
            }
        }
        task.resume()
    }
    // MARK: - 약속
    func loadPromise(completion: @escaping ([Promise]?) -> Void) async {
        let urlString = "https://payrit.info/api/v1/promise/list"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                if let data = data {
                    var data = data
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                        
                        if var jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                            for index in 0..<jsonArray.count {
                                let check: String? = jsonArray[index]["promiseImageType"] as? String
                                if check == nil {
                                    jsonArray[index]["promiseImageType"] = "PRESENT"
                                }
                                jsonArray[index]["isClicked"] = false
                            }
                            data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                        }
                        
                        let promises = try decoder.decode([Promise].self, from: data)
                        
                        completion(promises)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            } else {
                print("loadPromise HTTP status code: \(httpResponse.statusCode)")
                if let data = data {
                    print("loadPromise : \(data.dataToString())")
                }
            }
        }
        task.resume()
    }
    
    func loadPromiseDetail(id: Int, completion: @escaping (Promise) -> Void) async {
        let urlString = "https://payrit.info/api/v1/promise/detail/\(id)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                if let data = data {
                    var data = data
                    do {
                        let decoder = JSONDecoder()
                        let promises = try decoder.decode(Promise.self, from: data)
                        completion(promises)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            } else {
                print("loadPromise HTTP status code: \(httpResponse.statusCode)")
                if let data = data {
                    print("loadPromise : \(data.dataToString())")
                }
            }
        }
        task.resume()
    }
    
    func promiseDelete(id: Int, completion: @escaping (Bool) -> Void) {
        let urlString = "https://payrit.info/api/v1/promise/remove/\(id)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
                print("promiseDelete status code: \(httpResponse.statusCode)")
            if (200..<300).contains(httpResponse.statusCode) {
                print("약속 삭제 성공")
                completion(true)
            } else {
                print("약속 삭제 실패")
                if let data = data {
                    print(data.dataToString())
                }
            }
        }
        task.resume()
    }
    
    func addPromise(id: String) {
        let urlString = "https://payrit.info/api/v1/promise/share/\(id)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                print("약속 추가 성공")
                self.isAddedPromise = true
            } else {
                print("addPromise status code: \(httpResponse.statusCode)")
                if let data = data {
                    print("addPromise : \(data.dataToString())")
                }
            }
        }
        task.resume()
    }
    
    // MARK: - PDF변환
    @MainActor
    func generatePDF() -> URL {
        let renderer = ImageRenderer(content: CertificateDocumentView(certificateDetail: self.certificateDetail))
        
        let url = URL.documentsDirectory.appending(path: "\(Date().hyphenFomatter()) 페이릿 차용증.pdf")
        
        renderer.render { size, context in
            var pdfDimension = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &pdfDimension, nil) else {
                return
            }
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }
        return url
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
