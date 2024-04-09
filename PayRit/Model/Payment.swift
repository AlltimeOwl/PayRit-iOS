//
//  Payment.swift
//  PayRit
//
//  Created by 임대진 on 3/12/24.
//

import Foundation

struct Payment: Identifiable {
    let id: String = UUID().uuidString
    let money: String
    let day: String
    var paymentState: PaymentState
}

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
