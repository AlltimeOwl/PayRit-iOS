//
//  Document.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import Foundation
import SwiftUI

enum CertificateStep: String, CodingKey, Codable {
    case waitingApproval = "승인 대기중"
    case waitingPayment = "결제 대기중"
    case progress = "상환 진행중"
    case complete = "상환 완료"
    case modifying = "수정 요청중"
    case refused = "거절됨"
}

enum WriterRole: String, CodingKey, Codable {
    case CREDITOR
    case DEBTOR
}

struct CertificateDetail: Hashable, Codable {
    let paperId: Int
    let paperUrl: String?
    var memberRole: String
    var paperFormInfo: PaperFormInfo
    var repaymentRate: Double
    var creditorProfile: Creditor
    var debtorProfile: Debtor
    var dueDate: Int
    var memoListResponses: [Memo] = [Memo]()
    var repaymentHistories: [Deducted] = [Deducted]()
    var modifyRequest: String?
    
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
    
    static let EmptyCertificate: CertificateDetail = CertificateDetail(paperId: 0, paperUrl: nil, memberRole: "", paperFormInfo: PaperFormInfo(primeAmount: 0, interest: 0, amount: 0, remainingAmount: 0, interestRate: 0.0, interestPaymentDate: 0, repaymentStartDate: "", repaymentEndDate: "", transactionDate: "", specialConditions: ""), repaymentRate: 0.0, creditorProfile: Creditor(name: "", phoneNumber: "", address: ""), debtorProfile: Debtor(name: "", phoneNumber: "", address: ""), dueDate: 0)
}
