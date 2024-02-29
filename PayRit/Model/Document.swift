//
//  Document.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import Foundation

enum DocumentState {
    case first
    case second
    case third
}

struct Document: Identifiable {
    let id: String = UUID().uuidString
    let sender: String
    let senderPhoneNumber: String
    let recipient: String
    let recipientPhoneNumber: String
    
    let startDay: String
    let endDay: String
    let totalMoney: Int
    let interestRate: Double
    var state: DocumentState
    var totalAmount: Int {
        return totalMoney + Int((Double(totalMoney) * interestRate) / 100.0)
    }
    var totalMoneyFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: totalMoney))) ?? String(totalMoney)
    }
    var dDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let targetDate = dateFormatter.date(from: endDay) {
            let dday = calculateDday(targetDate: targetDate)
            return dday
        } else {
            print("날짜 변환 중 오류가 발생했습니다.")
            return ""
        }
    }
    
    static let samepleDocument: [Document] = [
        Document(sender: "홍길동", senderPhoneNumber: "01050097937", recipient: "빌린이1", recipientPhoneNumber: "01050097937", startDay: "2024.01.01", endDay: "2024-03-01", totalMoney: 30000000, interestRate: 5.0, state: .first),
        Document(sender: "홍길동", senderPhoneNumber: "01050097937", recipient: "빌린이2", recipientPhoneNumber: "01050097937", startDay: "2024.01.01", endDay: "2024-04-01", totalMoney: 20000000, interestRate: 5.0, state: .first),
        Document(sender: "홍길동", senderPhoneNumber: "01050097937", recipient: "빌린이3", recipientPhoneNumber: "01050097937", startDay: "2024.01.01", endDay: "2024-05-01", totalMoney: 14000000, interestRate: 5.0, state: .first),
        Document(sender: "홍길동", senderPhoneNumber: "01050097937", recipient: "빌린이4", recipientPhoneNumber: "01050097937", startDay: "2024.01.01", endDay: "2024-06-01", totalMoney: 16000000, interestRate: 5.0, state: .first),
        Document(sender: "홍길동", senderPhoneNumber: "01050097937", recipient: "빌린이5", recipientPhoneNumber: "01050097937", startDay: "2024.01.01", endDay: "2024-07-01", totalMoney: 22000000, interestRate: 5.0, state: .first)
    ]
}
func calculateDday(targetDate: Date) -> String {
    // 현재 날짜를 가져옵니다.
    let currentDate = Date()
    
    // Calendar 인스턴스를 생성합니다.
    let calendar = Calendar.current
    
    // 날짜 간의 차이를 계산합니다.
    let components = calendar.dateComponents([.day], from: currentDate, to: targetDate)
    
    // 디데이 결과를 문자열로 반환합니다.
    if let days = components.day {
        if days == 0 {
            return "D-0"
        } else if days > 0 {
            return "D-\(days)"
        } else {
            return "D+\(-days)"
        }
    } else {
        return "날짜를 가져오는 데 문제가 발생했습니다."
    }
}
