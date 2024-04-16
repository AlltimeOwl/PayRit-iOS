//
// Created by BingBong on 2021/06/30.
// Copyright (c) 2021 CocoaPods. All rights reserved.
//

import Foundation
import Then
import SwiftUI
import iamport_ios

public enum ItemType: Int, CaseIterable {
    case UserCode, PG, PayMethod, Carrier
    
    public var name: String {
        switch self {
        case .UserCode:
            return "가맹점 식별코드"
        case .PG:
            return "PG"
        case .PayMethod:
            return "결제수단"
        case .Carrier:
            return "(선택)통신사"
        }
    }
}
enum AuthType {
    case once
    case account
    case payment
}

public class IamportStore: ObservableObject, Then {
    @Published var cert: Cert // 옵저빙할 본인인증 데이터 객체
    @Published var isShowingDuplicateAlert = false
    
    @Published var isPayment: Bool = false
    @Published var isCert: Bool = false
    
    /// 계정 본인인증 여부
    @Published var authResult: Bool = false
    /// 차용증 승인시 본인인증 결과
    @Published var acceptAuthResult: Bool = false
    /// 결제 시도후 결과
    @Published var paymentResult: Bool = false
    @Published var amount: Int = 0
    @Published var impUid: String = ""
    @Published var merchantUid: String = ""
    
    /// 계정 인증 정보
    @Published var impAuth: Bool = UserDefaultsManager().getAuthState()
    var iamportResponse: IamportResponse?
    
    init() {
        cert = Cert().then { cert in
            cert.userCode.value = "imp28882037"
        }
    }
    
    func checkIMPAuth(completion: @escaping () -> Void) {
        let urlString = "https://payrit.info/api/v1/oauth/check"
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
            
            if httpResponse.statusCode == 204 {
                print("본인인증 완료된 계정")
                self.impAuth = true
                UserDefaultsManager().setAuthState(value: true)
                completion()
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                }
                self.impAuth = false
                UserDefaultsManager().setAuthState(value: false)
                completion()
            }
        }
        task.resume()
    }
    
    // 아임포트 본인인증 데이터 생성
    func createCertificationData() -> IamportCertification {
        IamportCertification(merchant_uid: UUID().uuidString).then {
            $0.min_age = Int(cert.minAge.value)
            $0.name = cert.name.value
            $0.phone = cert.phone.value
            $0.carrier = cert.carrier.value
        }
    }
    
    // 아임포트 결제 데이터 생성
    func createPaymentData(id: String, completion: @escaping (IamportPayment?, Error?) -> Void) {
        let urlString = "https://payrit.info/api/v1/transaction/paymentInfo/\(id)/PAPER_TRANSACTION"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
                        print(data)
                        let paymentData = try JSONDecoder().decode(PaymentData.self, from: data)
                        print(paymentData)
                        let req = IamportPayment(pg: paymentData.PGCode ?? "kcp.IP05D", merchant_uid: paymentData.merchantUID, amount: String(paymentData.amount)).then {
                            $0.name = paymentData.name
                            $0.buyer_name = paymentData.buyerName
                            $0.buyer_email = paymentData.buyerEmai
                            $0.buyer_tel = paymentData.buyerTel
                        }
                        self.amount = paymentData.amount
                        completion(req, nil)
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(nil, error)
                    }
                }
            } else {
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                }
                print("HTTP status code: \(httpResponse.statusCode)")
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    // 결제 완료 후 콜백 함수 (예시)
    func iamportCallback(type: AuthType, _ response: IamportResponse?, completion: @escaping (Bool?) -> Void) {
        print("------------------------------------------")
        print("iamportCallback 결과")
        if let res = response {
            print("Iamport response: \(res)")
            self.impUid = res.imp_uid ?? ""
            self.merchantUid = res.merchant_uid ?? ""
        }
        print("------------------------------------------")
        iamportResponse = response
        if type == .once {
            if let response {
                acceptAuthResult = response.success ?? false
            }
            completion(response?.success ?? false)
        } else if type == .account {
            if let response, let uid = response.imp_uid {
                self.sendCertificateResult(uid: uid) {
                    self.checkIMPAuth {
                        self.reloadCertificates {
                            self.authResult = response.success ?? false
                        }
                    }
                }
            }
            completion(response?.success ?? false)
        } else if type == .payment {
            if let response {
                paymentResult = response.success ?? false
            }
            completion(response?.success ?? false)
        }
        clearButton()
    }
    
    func clearButton() {
        isPayment = false
        isCert = false
    }
    
    func sendCertificateResult(uid: String, completion: @escaping () -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/oauth/certification/init"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            let body = [
                "impUid": uid
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
                } else if let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
                        print("impUid : \(uid)")
                        print("impUid 전송 완료")
                        completion()
                    } else if response.statusCode == 409 {
                        self.isShowingDuplicateAlert.toggle()
                        if let data = data {
                            let responseData = String(data: data, encoding: .utf8)
                            print("data: \(responseData ?? "No data")")
                        }
                    } else {
                        print("Unexpected status code: \(response.statusCode)")
                        if let data = data {
                            let responseData = String(data: data, encoding: .utf8)
                            print("data: \(responseData ?? "No data")")
                        }
                    }
                } else {
                    print("Unexpected error: No data or response")
                }
            }
            task.resume()
        }
    }
    
    func reloadCertificates(completion: @escaping () -> Void) {
        let urlString = "https://payrit.info/api/v1/paper/reload"
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
            
            print("HTTP status code: \(httpResponse.statusCode)")
            if (200..<300).contains(httpResponse.statusCode) {
                print("차용증 리로드 완료")
                completion()
            } else {
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                }
                completion()
            }
        }
        task.resume()
    }
}
