//
//  Payment.swift
//  PayRit
//
//  Created by 임대진 on 3/12/24.
//

import Foundation

struct PaymentData: Hashable, Codable {
    var PID: String?
    var PGCode: String?
    var merchantUID: String
    var name: String
    var amount: Int
    var buyerEmai: String?
    var buyerName: String?
    var buyerTel: String?
}

struct PaymentHistory: Hashable, Codable {
    var historyId: Int
    var transactionDate: String
    var amount: Int
    var transactionType: String
    var isSuccess: Bool
    
    var dateCal: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let targetDate = dateFormatter.date(from: transactionDate) {
            let writingDay = calculateDday(startDate: Date(), targetDate: targetDate)
            return writingDay
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
}

struct PaymentHistoryDetail: Hashable, Codable {
    var historyId: Int
    var transactionDate: String
    var approvalNumber: String
    var transactionType: String
    var amount: Int
}
