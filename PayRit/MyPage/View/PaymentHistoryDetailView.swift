//
//  PaymentHistoryDetail.swift
//  PayRit
//
//  Created by 임대진 on 4/13/24.
//

import SwiftUI

struct PaymentHistoryDetailView: View {
    let detail: PaymentHistoryDetail
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("결제한 내역")
                Text("을")
            }
            Text("안내해 드립니다.")
        }
        .navigationTitle("결제 상세 내역")
    }
}

#Preview {
    PaymentHistoryDetailView(detail: PaymentHistoryDetail(historyId: 0, transactionDate: "", approvalNumber: "", transactionType: "", amount: 0))
}
