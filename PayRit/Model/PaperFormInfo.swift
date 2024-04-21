//
//  PaperFormInfo.swift
//  PayRit
//
//  Created by 임대진 on 4/11/24.
//

import Foundation

struct PaperFormInfo: Hashable, Codable {
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
    var repaymentStartDate: String
    var repaymentEndDate: String
    var transactionDate: String
    var specialConditions: String
    
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
}
