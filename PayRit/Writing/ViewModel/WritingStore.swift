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
    
    init() {
        if UserDefaultsManager().getUserInfo().signInCompany == "애플" {
            currentUser = UserDefaultsManager().getAppleUserInfo()
        }
    }
    
    func saveCertificae(certificate: CertificateDetail, completion: @escaping (Bool) -> Void) {
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
                "amount": certificate.paperFormInfo.primeAmount,
                "interest": "\(certificate.paperFormInfo.interestRateAmount)",
                "transactionDate": Date().dateToString(),
                "repaymentStartDate": certificate.paperFormInfo.repaymentStartDate,
                "repaymentEndDate": certificate.paperFormInfo.repaymentEndDate,
                "specialConditions": certificate.paperFormInfo.specialConditions,
                "interestRate": "\(certificate.paperFormInfo.interestRate)",
                "interestPaymentDate": certificate.paperFormInfo.interestPaymentDate,
                "creditorName": certificate.creditorProfile.name,
                "creditorPhoneNumber": certificate.creditorProfile.phoneNumber,
                "creditorAddress": certificate.creditorProfile.address,
                "debtorName": certificate.debtorProfile.name,
                "debtorPhoneNumber": certificate.debtorProfile.phoneNumber,
                "debtorAddress": certificate.debtorProfile.address
            ] as [String: Any]
            print("-----HTTP 전송 바디-----")
            print(body)
            print("-----HTTP 전송 바디-----")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
                completion(false)
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion(false)
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
    
    func pixCertificae(certificate: CertificateDetail, id: Int, completion: @escaping (Bool) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/paper/modify/accept/\(id)"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            let body = [
                "writerRole": certificate.memberRole,
                "amount": certificate.paperFormInfo.primeAmount,
                "interest": "\(certificate.paperFormInfo.interestRateAmount)",
                "transactionDate": Date().dateToString(),
                "repaymentStartDate": certificate.paperFormInfo.repaymentStartDate,
                "repaymentEndDate": certificate.paperFormInfo.repaymentEndDate,
                "specialConditions": certificate.paperFormInfo.specialConditions,
                "interestRate": "\(certificate.paperFormInfo.interestRate)",
                "interestPaymentDate": certificate.paperFormInfo.interestPaymentDate,
                "creditorName": certificate.creditorProfile.name,
                "creditorPhoneNumber": certificate.creditorProfile.phoneNumber,
                "creditorAddress": certificate.creditorProfile.address,
                "debtorName": certificate.debtorProfile.name,
                "debtorPhoneNumber": certificate.debtorProfile.phoneNumber,
                "debtorAddress": certificate.debtorProfile.address
            ] as [String: Any]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
                completion(false)
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion(false)
                } else if let data = data, let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
                        print("차용증 수정 완료")
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                print("JSON Response: \(json)")
                            }
                        } catch {
                            print("Error parsing JSON response")
                        }
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
}
