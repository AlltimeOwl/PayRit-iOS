//
//  PaymentHistoryView.swift
//  PayRit
//
//  Created by 임대진 on 3/12/24.
//

import SwiftUI

struct PaymentHistoryView: View {
    let mypageStore: MyPageStore
    private let menuPadding = 8.0
    @State var detail: PaymentHistoryDetail?
    @State private var menuState = false
    @State private var isShowingDetailView = false
    @Environment(TabBarStore.self) var tabStore
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            if mypageStore.paymentHistory.isEmpty {
                VStack {
                    Text("결제 내역이 없습니다.")
                        .font(.system(size: 20))
                        .foregroundStyle(.gray).opacity(0.6)
                }
            } else {
                List(mypageStore.paymentHistory, id: \.self) { payment in
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(payment.transactionDate)
                                .font(Font.caption02)
                                .foregroundStyle(Color.gray05)
                            Spacer()
                            Button {
                                mypageStore.loadPaymentHistoryDetail(id: payment.historyId, completion: { detail, _ in
                                    self.detail = detail
                                    isShowingDetailView.toggle()
                                })
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                        }
                        .padding(.bottom, 12)
                        
                        Text("\(payment.amount)원")
                            .font(Font.title01)
                            .padding(.bottom, 2)
                        
                        Text(payment.paymentMethod)
                            .font(Font.title06)
                            .foregroundStyle(Color.gray05)
                        Spacer()
                        HStack {
                            Spacer()
                            Text(payment.isSuccess ? "결제 완료" : "결제 실패")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.payritMint)
                        }
                    }
                    .padding(16)
                    .frame(height: 170)
                    .frame(maxWidth: .infinity)
                    .background()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .customShadow()
                    .listRowBackground(Color.white)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .padding(.top, 50)
                
                // MARK: - 메뉴
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                menuState.toggle()
                            }
                        } label: {
                            if menuState == false {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "F2F2F2"), lineWidth: 2)
                                    .frame(width: 120, height: menuState ? 88 : 34)
                                    .background(Color.white)
                                    .clipShape(.rect(cornerRadius: 12))
                                    .customShadow()
                                    .overlay {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(mypageStore.sortingType.stringValue)
                                                Spacer()
                                                Image(systemName: "chevron.down")
                                            }
                                        }
                                        .padding(.horizontal, menuPadding)
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "F2F2F2"), lineWidth: 2)
                                    .frame(width: 120, height: menuState ? 62 : 34)
                                    .background(Color.white)
                                    .clipShape(.rect(cornerRadius: 12))
                                    .customShadow()
                                    .overlay {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Button {
                                                menuState.toggle()
                                            } label: {
                                                HStack {
                                                    Text(mypageStore.sortingType.stringValue)
                                                    Spacer()
                                                    Image(systemName: "chevron.up")
                                                }
                                            }
                                            ForEach(PaymentState.allCases, id: \.self) { state in
                                                if state != mypageStore.sortingType {
                                                    Button {
                                                        mypageStore.sortingType = state
                                                        menuState.toggle()
                                                        mypageStore.sortingPayment()
                                                    } label: {
                                                        HStack {
                                                            Text(state.rawValue)
                                                            Spacer()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, menuPadding)
                                    }
                            }
                        }
                    }
                    Spacer()
                }
                .font(Font.body03)
                .foregroundStyle(Color.gray02)
                .padding(.top, 10)
                .padding(.horizontal, 16)
            }
        }
        .dismissOnDrag()
        .navigationTitle("결제 내역")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            mypageStore.loadPaymentHistory()
        }
        .navigationDestination(isPresented: $isShowingDetailView) {
            if let detail = detail {
                PaymentHistoryDetailView(detail: detail)
                    .customBackbutton()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PaymentHistoryView(mypageStore: MyPageStore())
            .environment(TabBarStore())
    }
}
