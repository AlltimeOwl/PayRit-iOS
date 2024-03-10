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
    var writingDay: String
    var sender: String
    var senderPhoneNumber: String
    var senderAdress: String
    
    var recipient: String
    var recipientPhoneNumber: String
    var recipientAdress: String
    
    var tradeDay: String
    var endDay: String
    var totalMoney: Int
    var interestRate: Double
    
    var state: CertificateStep = .waitingApproval
    var type: CertificateType = .iLentYou
    
    var etc: String?
    var memo: [Memo]?
    var deductedAmount: [Int]?
    
    var totalAmount: Int {
        return (totalMoney + Int((Double(totalMoney) * interestRate) / 100.0)) - (deductedAmount?.reduce(0, +) ?? 0)
    }
    var totalMoneyFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: totalMoney))) ?? String(totalMoney)
    }
    var totalAmountFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: totalAmount))) ?? String(totalAmount)
    }
    var dDay: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        if let targetDate = dateFormatter.date(from: endDay) {
            let dDay = calculateDday(targetDate: targetDate)
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
            let writingDay = calculateDday(targetDate: targetDate)
            return writingDay
        } else {
            print("작성일 변환 중 오류가 발생했습니다.")
            return 0
        }
    }
    
    static var samepleDocument: [Certificate] = [
        Certificate(writingDay: "2024.02.01", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이1", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", tradeDay: "2024.01.01", endDay: "2024.08.01", totalMoney: 30000000, interestRate: 5.0, state: .waitingApproval, type: .iLentYou),
        Certificate(writingDay: "2024.01.21", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이2", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", tradeDay: "2024.01.01", endDay: "2024.04.01", totalMoney: 30000000, interestRate: 5.0, state: .complete, type: .iBorrowed),
        Certificate(writingDay: "2024.02.11", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이3", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", tradeDay: "2024.01.01", endDay: "2024.06.01", totalMoney: 30000000, interestRate: 5.0, state: .waitingPayment, type: .iLentYou),
        Certificate(writingDay: "2024..04.01", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이4", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", tradeDay: "2024.01.01", endDay: "2024.07.01", totalMoney: 30000000, interestRate: 5.0, state: .waitingApproval, type: .iBorrowed),
        Certificate(writingDay: "2024.03.05", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이5", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", tradeDay: "2024.01.01", endDay: "2024.05.21", totalMoney: 30000000, interestRate: 5.0, state: .waitingApproval, type: .iLentYou),
        Certificate(writingDay: "2024.03.21", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이6", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", tradeDay: "2024.01.01", endDay: "2024.05.01", totalMoney: 30000000, interestRate: 5.0, state: .waitingApproval, type: .iBorrowed)
    ]
    
    static let EmptyCertificate: Certificate = Certificate(writingDay: "", sender: "", senderPhoneNumber: "", senderAdress: "", recipient: "", recipientPhoneNumber: "", recipientAdress: "", tradeDay: "", endDay: "", totalMoney: 0, interestRate: 0.0)
}

func calculateDday(targetDate: Date) -> Int {
    // 현재 날짜를 가져옵니다.
    let currentDate = Date()
    
    // Calendar 인스턴스를 생성합니다.
    let calendar = Calendar.current
    
    // 날짜 간의 차이를 계산합니다.
    let components = calendar.dateComponents([.day], from: currentDate, to: targetDate)
    
    // 디데이 결과를 문자열로 반환합니다.
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
