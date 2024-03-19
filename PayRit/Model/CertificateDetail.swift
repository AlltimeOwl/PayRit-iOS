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
    let paperUrl: String
    var amount: Int
    
    /// 남은 금액(총액 - 일부상환액)
    var remainingAmount: Int
    var interestRate: Float
    var repaymentRate: Double
    var repaymentStartDate: String
    var repaymentEndDate: String
    var creditorName: String
    var creditorPhoneNumber: String
    var creditorAddress: String
    var debtorName: String
    var debtorPhoneNumber: String
    var debtorAddress: String
    var specialConditions: String?
    var repaymentHistories: [Deducted] = [Deducted]()
    
    //
    
//    var writerRole: WriterRole {
//        let userName = UserDefaultsManager().getUserInfo().name
//        if creditorName == userName {
//            return .CREDITOR
//        } else {
//            return .DEBTOR
//        }
//    }
    var writerRole: WriterRole = .CREDITOR
    var interestRateDay: String?
    var state: CertificateStep = .waitingApproval
    var memo: [Memo] = [Memo]()
    
    var interestRateAmount: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let targetDate = dateFormatter.date(from: repaymentEndDate), let startDate = dateFormatter.date(from: repaymentStartDate) {
            // 대출 기간 계산
            let totalDate = calculateDday(startDate: startDate, targetDate: targetDate) + 1
            
            // 일일 이자율 계산
            let dailyInterestRate = interestRate / 100.0 / 365.0
            
            // 이자 계산
            let interestAmount = Double(amount) * Double(dailyInterestRate) * Double(totalDate)
            
            // 이자를 정수로 반환
            return Int(interestAmount)
        } else {
            return 0
        }
    }

    
    var totalMoneyFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: amount))) ?? String(amount)
    }
    
    var totalInterestRateAmountFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: interestRateAmount))) ?? String(interestRateAmount)
    }
    
    var totalAmountFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: remainingAmount))) ?? String(remainingAmount)
    }
    
    var dDay: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let targetDate = dateFormatter.date(from: repaymentEndDate) {
            let dDay = calculateDday(startDate: Date(), targetDate: targetDate)
            return dDay
        } else {
            print("디데이 변환 중 오류가 발생했습니다.")
            return 0
        }
    }
    
    var calTotalDate: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let targetDate = dateFormatter.date(from: repaymentEndDate), let startDate = dateFormatter.date(from: repaymentStartDate) {
            // 대출 기간 계산
            let totalDate = calculateDday(startDate: startDate, targetDate: targetDate)
            
            return totalDate
        } else {
            return 0
        }
    }
    
//    var cardColor: Color {
//        let user = UserDefaultsManager().getUserInfo()
//        if creditorName == user.name {
//            return Color.payritMint
//        } else {
//            return Color.payritIntensivePink
//        }
//    }
    
    var cardName: String {
        let user = UserDefaultsManager().getUserInfo()
        if creditorName == user.name {
            return debtorName
        } else {
            return creditorName
        }
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
    
//    static let EmptyCertificate: CertificateDetail = CertificateDetail(writingDay: "", creditorName: "", creditorPhoneNumber: "", creditorAddress: "", debtorName: "", debtorPhoneNumber: "", debtorAddress: "", repaymentStartDate: "", repaymentEndDate: "", money: 0, interestRate: 0.0)
    static let EmptyCertificate: CertificateDetail = CertificateDetail(paperId: 0, paperUrl: "", amount: 0, remainingAmount: 0, interestRate: 0.0, repaymentRate: 0.0, repaymentStartDate: "", repaymentEndDate: "", creditorName: "", creditorPhoneNumber: "", creditorAddress: "", debtorName: "", debtorPhoneNumber: "", debtorAddress: "")
}
