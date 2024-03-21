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
//    var certificates: [Certificate] = Certificate.samepleDocument
    var certificates: [Certificate] = [Certificate]()
    var certificate: CertificateDetail = CertificateDetail(paperId: 0, paperUrl: "", amount: 0, memberRole: "", remainingAmount: 0, interestRate: 0.0, interestPaymentDate: 0, repaymentRate: 0.0, repaymentStartDate: "", repaymentEndDate: "", creditorName: "", creditorPhoneNumber: "", creditorAddress: "", debtorName: "", debtorPhoneNumber: "", debtorAddress: "")
    var isLoading: Bool = false
    
    init() {
        loadCertificates()
    }
    
    func loadCertificates() {
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
                    let responseData = String(data: data, encoding: .utf8)
                    print("Response data: \(responseData ?? "No data")")
//                    
                    do {
                        let certificates = try JSONDecoder().decode([Certificate].self, from: data)
                        
                        self.certificates = certificates
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
                        let certificates = try JSONDecoder().decode(CertificateDetail.self, from: data)
                        self.certificate = certificates
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
    
    func sortingCertificates() {
//        self.certificates = certificates.sorted {
//            switch sortingType {
//            case .recent:
//                return $0.writingDayCal > $1.writingDayCal
//            case .old:
//                return $0.writingDayCal < $1.writingDayCal
//            case .expiration:
//                return $0.dDay < $1.dDay
//            }}
    }
    // 홈에 새로 받은게 있나 검색
//    func checkNewReceived() -> [CertificateDetail]? {
//        let newRecived = certificates.filter { $0.writerRole == .CREDITOR }.filter { $0.debtorName == UserDefaultsManager().getUserInfo().name && $0.debtorPhoneNumber == UserDefaultsManager().getUserInfo().phoneNumber } + certificates.filter { $0.writerRole == .DEBTOR }.filter { $0.creditorName == UserDefaultsManager().getUserInfo().name && $0.creditorPhoneNumber == UserDefaultsManager().getUserInfo().phoneNumber }
//        return newRecived.filter { $0.state == .waitingApproval }
//    }
    
    // 내가 쓴건지 확인 맞으면 true
//    func checkIMadeIt(_ certificate: CertificateDetail) -> Bool {
//        let user = UserDefaultsManager().getUserInfo()
//        switch certificate.writerRole {
//        case .CREDITOR:
//            if certificate.debtorName == user.name {
//                return false
//            } else {
//                return true
//            }
//        case .DEBTOR:
//            if certificate.creditorName == user.name {
//                return false
//            } else {
//                return true
//            }
//        }
//    }
    
    func memoSave(paperId: Int, content: String) {
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
            ] as [String: Any]
            
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
//    
//    func deductedSave(certificate: CertificateDetail, date: String, money: Int) {
//        if let index = certificates.firstIndex(where: { $0.id == certificate.id }) {
//            var updatedCertificate = certificate
//            let newMemo = Deducted(date: date, money: money)
//            updatedCertificate.repaymentHistories.append(newMemo)
//            certificates[index] = updatedCertificate
//        }
//    }
    
    @MainActor 
    func generatePDF() -> URL {
        let renderer = ImageRenderer(content: CertificateDocumentView())
        
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
