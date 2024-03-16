//
//  Document.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import Foundation
import SwiftUI

enum CertificateStep: String, CodingKey {
    case waitingApproval = "승인 대기중"
    case waitingPayment = "결제 대기중"
    case progress = "상환 진행중"
}

enum WriterRole {
    case CREDITOR
    case DEBTOR
}

struct Certificate: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var writingDay: String = Date().dateToString()
    var WriterRole: WriterRole = .CREDITOR
    
    var creditorName: String
    var creditorPhoneNumber: String
    var creditorAddress: String
    
    var debtorName: String
    var debtorPhoneNumber: String
    var debtorAddress: String
    
    var repaymentStartDate: String
    var repaymentEndDate: String
    var money: Int
    var interestRate: Double
    var interestRateDay: String?
    
    var state: CertificateStep = .waitingApproval
    
    var etc: String?
    var memo: [Memo] = [Memo]()
    var deductedHistory: [Deducted] = [Deducted]()
    
//    var interestMoney: Int? {
//        let calendar = Calendar.current
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy.MM.dd"
//        let dailyInterestRate = interestRate / 365.0 / 100.0
//        let interestAmount = totalMoney * dailyInterestRate * Double(calendar.dateComponents([.day], from: , to: dateFormatter.date(from: interestRateDay?)).day ?? 0)
//        return interestAmount
//    }
    
    var interestRateAmount: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        if let targetDate = dateFormatter.date(from: repaymentEndDate), let startDate = dateFormatter.date(from: repaymentStartDate) {
            // 대출 기간 계산
            let totalDate = calculateDday(startDate: startDate, targetDate: targetDate) + 1
            
            // 일일 이자율 계산
            let dailyInterestRate = interestRate / 100.0 / 365.0
            
            // 이자 계산
            let interestAmount = Double(money) * dailyInterestRate * Double(totalDate)
            
            // 이자를 정수로 반환
            return Int(interestAmount)
        } else {
            return 0
        }
    }

    var totalAmount: Int {
        let total = (money + interestRateAmount) - (deductedHistory.reduce(0) { $0 + $1.money })
        if total < 0 {
            return 0
        } else {
            return total
        }
    }
    
    var totalMoneyFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: money))) ?? String(money)
    }
    
    var totalInterestRateAmountFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: interestRateAmount))) ?? String(interestRateAmount)
    }
    
    var totalAmountFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: totalAmount))) ?? String(totalAmount)
    }
    
    var dDay: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        if let targetDate = dateFormatter.date(from: repaymentEndDate) {
            let dDay = calculateDday(startDate: Date(), targetDate: targetDate)
            return dDay
        } else {
            print("디데이 변환 중 오류가 발생했습니다.")
            return 0
        }
    }
    
    var writingDayCal: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        if let targetDate = dateFormatter.date(from: writingDay) {
            let writingDay = calculateDday(startDate: Date(), targetDate: targetDate)
            return writingDay
        } else {
            print("작성일 변환 중 오류가 발생했습니다.")
            return 0
        }
    }
    
    var calTotalDate: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        if let targetDate = dateFormatter.date(from: repaymentEndDate), let startDate = dateFormatter.date(from: repaymentStartDate) {
            // 대출 기간 계산
            let totalDate = calculateDday(startDate: startDate, targetDate: targetDate)
            
            return totalDate
        } else {
            return 0
        }
    }
    
    var progressValue: Double {
        if deductedHistory.isEmpty {
            return 0.0
        } else {
            let sum = deductedHistory.reduce(0) { $0 + $1.money }
            if sum > money + interestRateAmount {
                return 100
            } else {
                let percentage = Double(totalAmount) / Double(money + interestRateAmount) * 100.0
                return (100 - percentage)            }
        }
    }
    
    var cardColor: Color {
        let user = UserDefaultsManager().getUserInfo()
        if creditorName == user.name {
            return Color.payritMint
        } else {
            return Color.payritIntensivePink
        }
    }
    
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
    
    static var samepleDocument: [Certificate] = [
//        Certificate(writingDay: "2024.01.01", creditorName: "홍길동", creditorPhoneNumber: "01050097937", creditorAddress: "경기도 용인시", debtorName: "임대진", debtorPhoneNumber: "01050097937", debtorAddress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.06.01", money: 30000000, interestRate: 5.0, interestRateDay: "2024.05.05", state: .progress, WriterRole: .CREDITOR, memo: [Memo(today: "2024.02.01", text: "10,000원을 한달뒤에 갚는다고 했음"), Memo(today: "2024.02.01", text: "10,000원을 한달뒤에 갚는다고 했음10,000원을 한달뒤에 갚는다고 했음"), Memo(today: "2024.02.01", text: "10,000원을 한달뒤에 갚는다고 했음10,000원을 한달뒤에 갚는다고 했음10,000원을 한달뒤에 갚는다고 했음")], deductedHistory: [Deducted(date: "2024.02.01", money: 1000), Deducted(date: "2024.02.01", money: 20000000), Deducted(date: "2024.02.01", money: 3000000)]),
//        Certificate(writingDay: "2024.01.03", creditorName: "임대진", creditorPhoneNumber: "01050097937", creditorAddress: "경기도 용인시", debtorName: "우리은행2", debtorPhoneNumber: "01050097937", debtorAddress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.06.01", money: 30000000, interestRate: 5.0, state: .progress, WriterRole: .CREDITOR),
//        Certificate(writingDay: "2024.01.11", creditorName: "홍길동", creditorPhoneNumber: "01050097937", creditorAddress: "경기도 용인시", debtorName: "임대진", debtorPhoneNumber: "01050097937", debtorAddress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.03.01", money: 30000000, interestRate: 5.0, state: .progress, WriterRole: .CREDITOR),
//        Certificate(writingDay: "2024.01.02", creditorName: "임대진", creditorPhoneNumber: "01050097937", creditorAddress: "경기도 용인시", debtorName: "우리은행4", debtorPhoneNumber: "01050097937", debtorAddress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.06.01", money: 30000000, interestRate: 5.0, state: .progress, WriterRole: .CREDITOR),
//        Certificate(writingDay: "2024.03.05", creditorName: "홍길동", creditorPhoneNumber: "01050097937", creditorAddress: "경기도 용인시", debtorName: "임대진", debtorPhoneNumber: "01050097937", debtorAddress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.02.01", money: 30000000, interestRate: 5.0, state: .progress, WriterRole: .CREDITOR),
//        Certificate(writingDay: "2024.03.11", creditorName: "임대진", creditorPhoneNumber: "01050097937", creditorAddress: "경기도 용인시", debtorName: "우리은행6", debtorPhoneNumber: "01050097937", debtorAddress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.09.01", money: 30000000, interestRate: 5.0, state: .progress, WriterRole: .CREDITOR)
        Certificate(writingDay: "2024.03.05", WriterRole: .CREDITOR, creditorName: "", creditorPhoneNumber: "01050097937", creditorAddress: "경기도 용인시", debtorName: "정주성1", debtorPhoneNumber: "01050097937", debtorAddress: "경기도 용인시", repaymentStartDate: "2024.02.01", repaymentEndDate: "2024.09.01", money: 1, interestRate: 0.0, interestRateDay: "", state: .waitingApproval, etc: ""),
        Certificate(writingDay: "2024.03.05", WriterRole: .DEBTOR, creditorName: "임대진", creditorPhoneNumber: "01050097937", creditorAddress: "경기도 용인시", debtorName: "정주성2", debtorPhoneNumber: "01050097937", debtorAddress: "경기도 용인시", repaymentStartDate: "2024.02.01", repaymentEndDate: "2024.09.01", money: 1, interestRate: 0.0, interestRateDay: "", state: .waitingPayment, etc: ""),
        Certificate(writingDay: "2024.03.05", WriterRole: .CREDITOR, creditorName: "정주성3", creditorPhoneNumber: "01050097937", creditorAddress: "경기도 용인시", debtorName: "임대진", debtorPhoneNumber: "01050097937", debtorAddress: "경기도 용인시", repaymentStartDate: "2024.02.01", repaymentEndDate: "2024.09.01", money: 1, interestRate: 0.0, interestRateDay: "", state: .waitingApproval, etc: ""),
        Certificate(writingDay: "2024.03.05", WriterRole: .DEBTOR, creditorName: "정주성4", creditorPhoneNumber: "01050097937", creditorAddress: "경기도 용인시", debtorName: "임대진", debtorPhoneNumber: "01050097937", debtorAddress: "경기도 용인시", repaymentStartDate: "2024.02.01", repaymentEndDate: "2024.09.01", money: 1, interestRate: 0.0, interestRateDay: "", state: .waitingApproval, etc: "")
    ]
    
    static let EmptyCertificate: Certificate = Certificate(writingDay: "", creditorName: "", creditorPhoneNumber: "", creditorAddress: "", debtorName: "", debtorPhoneNumber: "", debtorAddress: "", repaymentStartDate: "", repaymentEndDate: "", money: 0, interestRate: 0.0)
    
}
