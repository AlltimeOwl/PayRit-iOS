//
//  MyPageStore.swift
//  PayRit
//
//  Created by 임대진 on 3/8/24.
//

import Foundation

enum PaymentState: String, CodingKey, CaseIterable {
    case current = "최근 결제일 순"
    case expiration = "오래된 결제 순"
}

@Observable
final class MyPageStore {
    var paymentHistory: [Payment] = [Payment]()
    var sortingType: PaymentState = .current
    
    init() {
        paymentHistory = generateRandomPayments(count: 10)
    }
    
    func sortingPayment() {
        if sortingType == .current {
            paymentHistory.sort { $0.day > $1.day }
        } else {
            paymentHistory.sort { $0.day < $1.day }
        }
    }
    
    func generateRandomPayments(count: Int) -> [Payment] {
        var payments = [Payment]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        for _ in 0..<count {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let randomMoney = formatter.string(from: (NSNumber(value: Int.random(in: 1000..<5000)))) ?? String(Int.random(in: 1000..<5000))
            let randomDay = dateFormatter.string(from: Date(timeIntervalSinceNow: TimeInterval.random(in: -86400 * 30 * 12...0))) // 최근 1년 이내의 임의의 날짜 생성
            let randomPaymentState = [PaymentState.current, PaymentState.expiration].randomElement()!
            let payment = Payment(money: randomMoney, day: randomDay, paymentState: randomPaymentState)
            payments.append(payment)
        }
        
        return payments
    }
}
