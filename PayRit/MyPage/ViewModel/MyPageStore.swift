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

@Observable
final class MyPageStore {
    let userDefaultsManager = UserDefaultsManager()
    var currentUser: User = User(name: "", email: "", phoneNumber: "", signInCompany: "")
    var userCertInfo: CertificationInfo?
    var paymentHistory: [Payment] = [Payment]()
    var sortingType: PaymentState = .current
    var impAuth: Bool = false
    
    init() {
        if userDefaultsManager.getUserInfo().signInCompany == "애플" {
            currentUser = userDefaultsManager.getAppleUserInfo()
        } else if userDefaultsManager.getUserInfo().signInCompany == "카카오톡" {
            currentUser = userDefaultsManager.getUserInfo()
        }
        paymentHistory = generateRandomPayments(count: 10)
        checkIMPAuth()
    }
    
    func sortingPayment() {
        if sortingType == .current {
            paymentHistory.sort { $0.day > $1.day }
        } else {
            paymentHistory.sort { $0.day < $1.day }
        }
    }
    
    func generateRandomPayments(count: Int) -> [Payment] {
        var payments = [Payment]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for _ in 0..<count {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let randomMoney = formatter.string(from: (NSNumber(value: Int.random(in: 1000..<5000)))) ?? String(Int.random(in: 1000..<5000))
            let randomDay = dateFormatter.string(from: Date(timeIntervalSinceNow: TimeInterval.random(in: -86400 * 30 * 12...0))) // 최근 1년 이내의 임의의 날짜 생성
            let randomPaymentState = [PaymentState.current, PaymentState.expiration].randomElement()!
            let payment = Payment(money: randomMoney, day: randomDay, paymentState: randomPaymentState)
            payments.append(payment)
        }
        
        return payments
    }
    
    func checkIMPAuth() {
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
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                }
                self.impAuth = false
            }
        }
        task.resume()
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
}
