//
//  Document.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import Foundation
import SwiftUI

enum CertificateStep: String, CodingKey, Codable {
    case waitingApproval = "승인 대기중"
    case waitingPayment = "결제 대기중"
    case progress = "상환 진행중"
}

enum WriterRole: String, CodingKey, Codable {
    case CREDITOR
    case DEBTOR
}

struct CertificateDetail: Hashable, Codable {
    let paperId: Int
    let paperUrl: String?
    var memberRole: String
    
    /// 순수 원금
    var primeAmount: Int
    
    /// 이자액
    var interest: Int
    
    /// 총액( 원금 + 이자 )
    var amount: Int
    
    /// 남은 금액(총액 - 일부상환액)
    var remainingAmount: Int
    
    var interestRate: Float
    var interestPaymentDate: Int
    var repaymentRate: Double
    var repaymentStartDate: String
    var repaymentEndDate: String
    var transactionDate: String
    var creditorName: String
    var creditorPhoneNumber: String
    var creditorAddress: String
    var dueDate: Int
    var debtorName: String
    var debtorPhoneNumber: String
    var debtorAddress: String
    var specialConditions: String?
    var memoListResponses: [Memo] = [Memo]()
    var repaymentHistories: [Deducted] = [Deducted]()
    
    var interestRateAmount: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let targetDate = dateFormatter.date(from: repaymentEndDate), let startDate = dateFormatter.date(from: repaymentStartDate) {
            let totalDate = calculateDday(startDate: startDate, targetDate: targetDate) + 1
            let dailyInterestRate = interestRate / 100.0 / 365.0
            let interestAmount = Double(primeAmount) * Double(dailyInterestRate) * Double(totalDate)
            return Int(interestAmount)
        } else {
            return 0
        }
    }
    
    /// primeAmount 순수 원금 값 포멧
    var primeAmountFomatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: primeAmount))) ?? String(primeAmount)
    }
    
    /// remainingAmount 값 포멧
    var remainingAmountFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: remainingAmount))) ?? String(remainingAmount)
    }
    
    /// 서버에서 받은 interest 이자금액 포멧
    var interestFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: interest))) ?? String(interest)
    }
    /// amount (원금 + 이자) 포멧
    var amountFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: amount))) ?? String(amount)
    }
    
    /// 작성시 사용하는 원금 + 이자 금액 포멧
    var totalAmountFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: primeAmount + interestRateAmount))) ?? String(primeAmount + interestRateAmount)
    }
    
    func calculateDday(startDate: Date, targetDate: Date) -> Int {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: startDate, to: targetDate)
        
        if let days = components.day {
            if days == 0 {
                // 당일
                return 0
            } else if days > 0 {
                // 남은 일
                return days
            } else {
                // 만료 이후
                return days
            }
        } else {
            return 0
        }
    }
    
    static let EmptyCertificate: CertificateDetail = CertificateDetail(paperId: 0, paperUrl: "", memberRole: "", primeAmount: 0, interest: 0, amount: 0, remainingAmount: 0, interestRate: 0.0, interestPaymentDate: 0, repaymentRate: 0.0, repaymentStartDate: "", repaymentEndDate: "",transactionDate: "" , creditorName: "", creditorPhoneNumber: "", creditorAddress: "", dueDate: 0, debtorName: "", debtorPhoneNumber: "", debtorAddress: "")
    static let testCertofocateDetail: CertificateDetail = CertificateDetail(paperId: 0, paperUrl: "", memberRole: "CREDITOR", primeAmount: 100000000, interest: 10000000, amount: 110000000, remainingAmount: 100000000, interestRate: 19.99, interestPaymentDate: 10, repaymentRate: 0.0, repaymentStartDate: "2024-03-01", repaymentEndDate: "2026-03-01", transactionDate: "2024-03-01", creditorName: "임대진", creditorPhoneNumber: "010-5009-7937", creditorAddress: "주소주소주소주소주소주소주소주소주소주소주소주소주소", dueDate: 0, debtorName: "상대방", debtorPhoneNumber: "010-5050-5050", debtorAddress: "")
}
