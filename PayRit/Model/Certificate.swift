//
//  Document.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import Foundation

enum CertificateStep: String, CodingKey {
    case waitingApproval = "승인 대기중"
    case waitingPayment = "결제 대기중"
    case complete = "상환 진행중"
}

enum CertificateType: String, CodingKey {
    case iLentYou = "빌려준 돈"
    case iBorrowed = "빌린 돈"
}

struct Certificate: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var writingDay: String = Date().dateToString()
    
    var sender: String
    var senderPhoneNumber: String
    var senderAdress: String
    
    var recipient: String
    var recipientPhoneNumber: String
    var recipientAdress: String
    
    var borrowedDate: String
    var redemptionDate: String
    var money: Int
    var interestRate: Double
    var interestRateDay: String?
    
    var state: CertificateStep = .waitingApproval
    var type: CertificateType = .iLentYou
    
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

        if let targetDate = dateFormatter.date(from: redemptionDate), let startDate = dateFormatter.date(from: borrowedDate) {
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
        return (money + interestRateAmount) - (deductedHistory.reduce(0) { $0 + $1.money })
    }
    
    var totalMoneyFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: money))) ?? String(money)
    }
    var totalAmountFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: totalAmount))) ?? String(totalAmount)
    }
    var dDay: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        if let targetDate = dateFormatter.date(from: redemptionDate) {
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

        if let targetDate = dateFormatter.date(from: redemptionDate), let startDate = dateFormatter.date(from: borrowedDate) {
            // 대출 기간 계산
            let totalDate = calculateDday(startDate: startDate, targetDate: targetDate)
            
            return totalDate
        } else {
            return 0
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
        Certificate(writingDay: "2024.02.01", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "임대진", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.01.01", money: 30000000, interestRate: 5.0, interestRateDay: "2024.05.05", state: .waitingApproval, type: .iLentYou, memo: [Memo(today: "2024.02.01", text: "10,000원을 한달뒤에 갚는다고 했음"), Memo(today: "2024.02.01", text: "10,000원을 한달뒤에 갚는다고 했음10,000원을 한달뒤에 갚는다고 했음"), Memo(today: "2024.02.01", text: "10,000원을 한달뒤에 갚는다고 했음10,000원을 한달뒤에 갚는다고 했음10,000원을 한달뒤에 갚는다고 했음")], deductedHistory: [Deducted(date: "2024.02.01", money: 1000), Deducted(date: "2024.02.01", money: 20000000), Deducted(date: "2024.02.01", money: 3000000)]),
        Certificate(writingDay: "2024.01.21", sender: "임대진", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "우리은행2", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.01.01", money: 30000000, interestRate: 5.0, state: .complete, type: .iBorrowed),
        Certificate(writingDay: "2024.02.11", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "임대진", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.03.01", money: 30000000, interestRate: 5.0, state: .waitingPayment, type: .iLentYou),
        Certificate(writingDay: "2024.04.01", sender: "임대진", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "우리은행4", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.01.01", money: 30000000, interestRate: 5.0, state: .waitingApproval, type: .iBorrowed),
        Certificate(writingDay: "2024.03.05", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "임대진", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.02.01", money: 30000000, interestRate: 5.0, state: .waitingApproval, type: .iLentYou),
        Certificate(writingDay: "2024.03.21", sender: "임대진", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "우리은행6", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", borrowedDate: "2024.01.05", redemptionDate: "2024.01.01", money: 30000000, interestRate: 5.0, state: .waitingApproval, type: .iBorrowed)
    ]
    
    static let EmptyCertificate: Certificate = Certificate(writingDay: "", sender: "", senderPhoneNumber: "", senderAdress: "", recipient: "", recipientPhoneNumber: "", recipientAdress: "", borrowedDate: "", redemptionDate: "", money: 0, interestRate: 0.0)
}
