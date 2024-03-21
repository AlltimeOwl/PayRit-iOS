//
//  PaymentHistoryView.swift
//  PayRit
//
//  Created by 임대진 on 3/12/24.
//

import SwiftUI

struct PaymentHistoryView: View {
    @State private var menuState = false
    @Environment(TabBarStore.self) var tabStore
    private let menuPadding = 8.0
    var myPageStore: MyPageStore = MyPageStore()
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            List(myPageStore.paymentHistory) { payment in
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(payment.day)
                            .font(Font.caption02)
                            .foregroundStyle(Color.gray05)
                        Spacer()
                        Image(systemName: "ellipsis")
                    }
                    .padding(.bottom, 12)
                    
                    Text("\(payment.money)원")
                        .font(Font.title01)
                        .padding(.bottom, 2)
                    
                    Text("카드결제")
                        .font(Font.title06)
                        .foregroundStyle(Color.gray05)
                    Spacer()
                    HStack {
                        Spacer()
                        Text("결제 완료")
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
                .shadow(color: .gray.opacity(0.2), radius: 5)
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
                                .shadow(color: .gray.opacity(0.2), radius: 5)
                                .overlay {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(myPageStore.sortingType.stringValue)
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
                                .shadow(color: .gray.opacity(0.2), radius: 5)
                                .overlay {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Button {
                                            menuState.toggle()
                                        } label: {
                                            HStack {
                                                Text(myPageStore.sortingType.stringValue)
                                                Spacer()
                                                Image(systemName: "chevron.up")
                                            }
                                        }
                                        ForEach(PaymentState.allCases, id: \.self) { state in
                                            if state != myPageStore.sortingType {
                                                Button {
                                                    myPageStore.sortingType = state
                                                    menuState.toggle()
                                                    myPageStore.sortingPayment()
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
        .dismissOnDrag()
        .navigationTitle("결제 내역")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PaymentHistoryView()
            .environment(TabBarStore())
    }
}
