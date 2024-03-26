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
                    let responseData = String(data: data, encoding: .utf8)
                    print("Response data: \(responseData ?? "No data")")
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
                        if ((self.certificateDetail.specialConditions?.isEmpty) != nil) {
                            self.certificateDetail.specialConditions = nil
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
    
    func acceptCertificate(paperId: Int) {
        let urlString = "https://payrit.info/api/v1/paper/approve/accept/\(paperId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (_, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            if (200..<300).contains(httpResponse.statusCode) {
                print("차용증 승인 요청 성공")
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
            }
            
        }
        task.resume()
    }
    
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
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
                        print("response.statusCode [\(response.statusCode) 메모 작성 성공")
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
    
    func deductedSave(paperId: Int, repaymentDate: String, repaymentAmount: String) {
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
    
    func kakaoMessageTest(paperId: Int, repaymentDate: String, repaymentAmount: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "bizmsg-web.kakaoenterprise.com"
        urlComponents.path = "/v1/message/send"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            let body = [
                "client_id": "1050643",
                "message_type": "AT",
                "sender_key": "string",
                "phone_number": "string",
                "message": "string",
                "template_code": "string",
                "sms_message": "string",
                "sms_type": "SM",
                "etc1": "string",
                "sender_no": "string"
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
}
