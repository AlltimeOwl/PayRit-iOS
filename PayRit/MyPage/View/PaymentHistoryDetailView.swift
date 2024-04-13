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
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text("결제한 내역")
                            .foregroundStyle(Color.payritMint)
                        Text("을")
                    }
                    .padding(.top, 40)
                    Text("안내해 드립니다.")
                }
                .font(Font.title01)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(Color.gray03)
                    .padding(.top, 24)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("승인일시")
                            .foregroundStyle(Color.gray06)
                        Spacer()
                        Text(detail.transactionDate)
                    }
                    .font(Font.title06)
                    .padding(.top, 27)
                    
                    HStack {
                        Text("승인번호")
                            .foregroundStyle(Color.gray06)
                        Spacer()
                        Text(detail.approvalNumber)
                    }
                    .font(Font.title06)
                    HStack {
                        Text("결제수단")
                            .foregroundStyle(Color.gray06)
                        Spacer()
                        Text(detail.transactionType)
                    }
                    .font(Font.title06)
                    HStack {
                        Text("상품금액")
                            .foregroundStyle(Color.gray06)
                        Spacer()
                        Text(detail.amount.amountFormatter() + "원")
                    }
                    .font(Font.title06)
                }
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(Color.gray07)
                    .padding(.top, 24)
                
                HStack {
                    Text("총 결제 금액")
                        .font(Font.title04)
                    Spacer()
                    Text(detail.amount.amountFormatter() + "원")
                        .foregroundStyle(Color.payritMint)
                        .font(Font.title01)
                }
                .padding(.top, 31.5)
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("결제 상세 내역")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PaymentHistoryDetailView(detail: PaymentHistoryDetail(historyId: 1, transactionDate: "2024-03-26", approvalNumber: "231231", transactionType: "신한 체크카드 (0313)", amount: 1000))
    }
}
