//
//  Document.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import Foundation

enum DocumentState: String, CodingKey {
    case first = "승인 대기중"
    case second = "결제 대기중"
    case third = "차용증 작성 완료"
}

struct Document: Identifiable {
    let id: String = UUID().uuidString
    let writingDay: String
    let sender: String
    let senderPhoneNumber: String
    let senderAdress: String
    
    let recipient: String
    let recipientPhoneNumber: String
    let recipientAdress: String
    
    let startDay: String
    let endDay: String
    let totalMoney: Int
    let interestRate: Double
    
    var state: DocumentState = .first
    
    var totalAmount: Int {
        return totalMoney + Int((Double(totalMoney) * interestRate) / 100.0)
    }
    var totalMoneyFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: totalMoney))) ?? String(totalMoney)
    }
    var dDay: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

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
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let targetDate = dateFormatter.date(from: writingDay) {
            let writingDay = calculateDday(targetDate: targetDate)
            return writingDay
        } else {
            print("작성일 변환 중 오류가 발생했습니다.")
            return 0
        }
    }
    
    static var samepleDocument: [Document] = [
        Document(writingDay: "2024-02-01", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이1", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", startDay: "2024-01-01", endDay: "2024-08-01", totalMoney: 30000000, interestRate: 5.0, state: .first),
        Document(writingDay: "2024-01-21", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이2", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", startDay: "2024-01-01", endDay: "2024-04-01", totalMoney: 30000000, interestRate: 5.0, state: .third),
        Document(writingDay: "2024-02-11", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이3", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", startDay: "2024-01-01", endDay: "2024-06-01", totalMoney: 30000000, interestRate: 5.0, state: .second),
        Document(writingDay: "2024-04-01", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이4", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", startDay: "2024-01-01", endDay: "2024-07-01", totalMoney: 30000000, interestRate: 5.0, state: .first),
        Document(writingDay: "2024-03-05", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이5", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", startDay: "2024-01-01", endDay: "2024-05-21", totalMoney: 30000000, interestRate: 5.0, state: .first),
        Document(writingDay: "2024-03-21", sender: "홍길동", senderPhoneNumber: "01050097937", senderAdress: "경기도 용인시", recipient: "빌린이6", recipientPhoneNumber: "01050097937", recipientAdress: "경기도 안양시", startDay: "2024-01-01", endDay: "2024-05-01", totalMoney: 30000000, interestRate: 5.0, state: .first)
    ]
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
