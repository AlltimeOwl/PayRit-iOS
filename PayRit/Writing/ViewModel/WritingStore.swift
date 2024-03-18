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
    
    func phoneNumberFormatter(number: String) -> String {
        if number.count == 11 {
            let firstPart = number.prefix(3)
            let secondPart = number[number.index(number.startIndex, offsetBy: 3)..<number.index(number.startIndex, offsetBy: 7)]
            let thirdPart = number.suffix(4)
            return "\(firstPart)-\(secondPart)-\(thirdPart)"
        } else {
            return number
        }
    }
    
    func globalPhoneNumber(_ number: String) -> String {
        var newNumber = number
        if !newNumber.isEmpty {
            newNumber.removeFirst()
        }
        return "+82 \(newNumber)"
    }
    
    func saveCertificae(certificate: Certificate) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/paper/write"
        
        // URL 구성 요소를 사용하여 URL 생성
        if let url = urlComponents.url {
//            print("URL: \(url)")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
//            print("Send Certificate : \(certificate)")
//             HTTP 바디 설정
            let body = [
                "writerRole": certificate.WriterRole.stringValue,
                "amount": "\(certificate.money)",
                "transactionDate": certificate.writingDay.replacingOccurrences(of: ".", with: "-"),
                "repaymentStartDate": certificate.repaymentStartDate.replacingOccurrences(of: ".", with: "-"),
                "repaymentEndDate": certificate.repaymentEndDate.replacingOccurrences(of: ".", with: "-"),
                "specialConditions": certificate.etc ?? "",
                "interestRate": "\(certificate.interestRate)",
                "interestPaymentDate": certificate.interestRateDay ?? "",
                "creditorName": certificate.creditorName,
                "creditorPhoneNumber": globalPhoneNumber(certificate.creditorPhoneNumber),
                "creditorAddress": certificate.creditorAddress,
                "debtorName": certificate.debtorName,
                "debtorPhoneNumber": globalPhoneNumber(certificate.debtorPhoneNumber),
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
            // URLSession을 사용하여 요청 수행
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
    
    func convertToKoreanNumber(_ number: Int) -> String {
        let numbers = ["영", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"]
        let units = ["", "십", "백", "천"]
        let largeUnits = ["", "만", "억", "조", "경", "해"]
        
        var result = ""
        var number = number
        var unitIndex = 0
        
        while number > 0 {
            let digit = number % 10
            let unit = units[unitIndex % 4]
            let largeUnit = largeUnits[unitIndex / 4]
            
            if digit != 0 {
                result = numbers[digit] + unit + result
            }
            
            number /= 10
            unitIndex += 1
            
            if unitIndex % 4 == 0 {
                result = largeUnit + result
            }
        }
        
        return result.isEmpty ? "영" : result
    }

}
