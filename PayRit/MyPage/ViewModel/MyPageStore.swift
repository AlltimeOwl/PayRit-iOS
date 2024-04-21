//
//  MyPageStore.swift
//  PayRit
//
//  Created by 임대진 on 3/8/24.
//

import Foundation

enum PaymentState: String, CodingKey, CaseIterable {
    case current = "최근 결제일 순"
    case expiration = "오래된 결제 순"
}

enum AlamRequestType {
    case load
    case send
}

@Observable
final class MyPageStore {
    let userDefaultsManager = UserDefaultsManager()
    var currentUser: User = User(name: "", email: "", phoneNumber: "", signInCompany: "")
    var userCertInfo: CertificationInfo?
    var paymentHistory: [PaymentHistory] = [PaymentHistory]()
    var sortingType: PaymentState = .current
    
    init() {
        if userDefaultsManager.getUserInfo().signInCompany == "애플" {
            currentUser = userDefaultsManager.getAppleUserInfo()
        } else if userDefaultsManager.getUserInfo().signInCompany == "카카오톡" {
            currentUser = userDefaultsManager.getUserInfo()
        }
    }
    
    func sortingPayment() {
        if sortingType == .current {
            paymentHistory.sort { $0.dateCal > $1.dateCal }
        } else {
            paymentHistory.sort { $0.dateCal < $1.dateCal }
        }
    }
    
    func loadCertInfo() {
        let urlString = "https://payrit.info/api/v1/profile/certification"
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
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let userCertInfo = try JSONDecoder().decode(CertificationInfo.self, from: data)
                        self.userCertInfo = userCertInfo
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
    
    func loadPaymentHistory() {
        let urlString = "https://payrit.info/api/v1/transaction/list"
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
            
            print("HTTP status code: \(httpResponse.statusCode)")
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let paymentHistory = try JSONDecoder().decode([PaymentHistory].self, from: data)
                        self.paymentHistory = paymentHistory
                        print("결제 내역: \(paymentHistory)")
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            } else {
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                }
            }
        }
        task.resume()
    }
    
    func loadPaymentHistoryDetail(id: Int, completion: @escaping (PaymentHistoryDetail?, Error?) -> Void) {
        let urlString = "https://payrit.info/api/v1/transaction/detail/\(id)"
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
            
            print("HTTP status code: \(httpResponse.statusCode)")
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let detail = try JSONDecoder().decode(PaymentHistoryDetail.self, from: data)
                        completion(detail, nil)
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(nil, nil)
                    }
                }
            } else {
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                }
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    func alamRequest(type: AlamRequestType, completion: @escaping (Bool) -> Void) {
        let urlString = "https://payrit.info/api/v1/profile/\(type == .load ? "status" : "notification")"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        print(urlString)
        
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
            
            print(httpResponse.statusCode)
            if (200..<300).contains(httpResponse.statusCode) {
                if let data = data {
                    if type == .load {
                        do {
                            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                                print("Error: Unable to convert JSON data to dictionary")
                                return
                            }
                            if let isAgreeNotification = json["isAgreeNotification"] as? Bool {
                                print("isAgreeNotification: \(isAgreeNotification)")
                                completion(isAgreeNotification)
                            } else {
                                print("Error: 'isAgreeNotification' key not found or value is not a boolean")
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }
            } else {
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                }
            }
        }
        task.resume()
    }
}
