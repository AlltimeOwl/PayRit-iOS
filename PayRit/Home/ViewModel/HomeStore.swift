//
//  HomeViewModel.swift
//  PayRit
//
//  Created by 임대진 on 3/2/24.
//

import SwiftUI
import PDFKit

enum SortingType: String, CodingKey, CaseIterable {
    case recent = "최근 거래 순"
    case old = "오래된 순"
    case expiration = "기간 만료 순"
}

@Observable
final class HomeStore {
    var sortingType: SortingType = .recent
    var certificates: [Certificate] = [Certificate]()
    var certificateDetail: CertificateDetail = CertificateDetail.EmptyCertificate
    var isShowingPaymentSuccessAlert: Bool = false
    var isLoading: Bool = true
    
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
                        if (self.certificateDetail.paperFormInfo.specialConditions?.isEmpty) != nil {
                            self.certificateDetail.paperFormInfo.specialConditions = nil
                        }
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
                } else {
                    print("Unexpected status code: \(response.statusCode)")
                }
            } else {
                print("Unexpected error: No data or response")
            }
        }
        task.resume()
    }
    
    func savePaymentHistory(paperId: Int) {
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
                "transactionDate": "2024-04-13T20:18:30",
                "amount": 1000,
                "contents": "차용증 카드 결제",
                "transactionType": "국민카드 (3003)",
                "approvalNumber": "30312313",
                "orderNumber": "imp12355578",
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
    
    // MARK: - PDF변환
    @MainActor
    func generatePDF() -> URL {
        let renderer = ImageRenderer(content: CertificateDocumentView(certificateDetail: self.certificateDetail))
        
        let url = URL.documentsDirectory.appending(path: "\(Date().dateToString()) 페이릿 차용증.pdf")
        
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
