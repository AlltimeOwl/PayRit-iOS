//
//  Certificate.swift
//  PayRit
//
//  Created by 임대진 on 3/19/24.
//

import Foundation

struct Certificate: Hashable, Codable {
    let paperId: Int
    let paperRole: WriterRole
    var transactionDate: String
    let repaymentStartDate: String
    let repaymentEndDate: String
    let amount: Int
    let paperStatus: String
    let peerName: String
    let dueDate: Int
    let repaymentRate: Double
    let isWriter: Bool
    
    var certificateStep: CertificateStep {
        if paperStatus == "WAITING_AGREE" {
            return .waitingApproval
        } else if paperStatus == "PAYMENT_REQUIRED" {
            return .waitingPayment
        } else if paperStatus == "COMPLETE_WRITING" {
            return .progress
        } else {
            return .waitingApproval
        }
    }
    
    var amountFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: (NSNumber(value: amount))) ?? String(amount)
    }
    
    var writingDayCal: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let targetDate = dateFormatter.date(from: transactionDate) {
            let writingDay = calculateDday(startDate: Date(), targetDate: targetDate)
            return writingDay
        } else {
            print("작성일 변환 중 오류가 발생했습니다.")
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
//    enum CodingKeys : String, CodingKey{
//        case name
//        case age
//        case birthday = "birth_date"
//    }
}
