//
//  WritingStore.swift
//  PayRit
//
//  Created by 임대진 on 3/13/24.
//

import Foundation
import SwiftUI

@Observable
final class WritingStore {
    var currentUser = UserDefaultsManager().getUserInfo()
    var impAuth = false
    
    init() {
        if UserDefaultsManager().getUserInfo().signInCompany == "애플" {
            currentUser = UserDefaultsManager().getAppleUserInfo()
        }
        checkIMPAuth()
    }
//    func calInterestAmount(start: String, end: String, rate: Float, primeAmount: Int) -> Int {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        if let targetDate = dateFormatter.date(from: end), let startDate = dateFormatter.date(from: start) {
//            let totalDate = calculateDday(startDate: startDate, targetDate: targetDate) + 1
//            let dailyInterestRate = rate / 100.0 / 365.0
//            let interestAmount = Double(primeAmount) * Double(dailyInterestRate) * Double(totalDate)
//            return Int(interestAmount)
//        } else {
//            return 0
//        }
//    }
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
            
            if (200..<300).contains(httpResponse.statusCode) {
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("Response data: \(responseData ?? "No data")")
                    do {
                        let certificate = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let impAuth = certificate?["success"] as? Bool ?? false
                        self.impAuth = impAuth
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
    
    func saveCertificae(certificate: CertificateDetail) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/paper/write"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            let body = [
                "writerRole": certificate.memberRole,
                "amount": certificate.primeAmount,
                "interest": "\(certificate.interestRateAmount)",
                "transactionDate": Date().dateToString(),
                "repaymentStartDate": certificate.repaymentStartDate,
                "repaymentEndDate": certificate.repaymentEndDate,
                "specialConditions": certificate.specialConditions ?? "",
                "interestRate": "\(certificate.interestRate)",
                "interestPaymentDate": certificate.interestPaymentDate,
                "creditorName": certificate.creditorName,
                "creditorPhoneNumber": certificate.creditorPhoneNumber.globalPhoneNumber(),
                "creditorAddress": certificate.creditorAddress,
                "debtorName": certificate.debtorName,
                "debtorPhoneNumber": certificate.debtorPhoneNumber.globalPhoneNumber(),
                "debtorAddress": certificate.debtorAddress
            ] as [String: Any]
            print("-----HTTP 전송 바디-----")
            print(body)
            print("-----HTTP 전송 바디-----")
            
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
                        // Handle successful response
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                print("JSON Response: \(json)")
                            }
                        } catch {
                            print("Error parsing JSON response")
                        }
                    } else {
                        // Handle other status codes
                        print("Unexpected status code: \(response.statusCode)")
                    }
                } else {
                    // Handle unexpected cases
                    print("Unexpected error: No data or response")
                }
            }
            task.resume() // 작업 시작
        }
    }
}
