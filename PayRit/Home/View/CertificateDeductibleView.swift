//
//  CertificateDeductibleView.swift
//  PayRit
//
//  Created by 임대진 on 3/11/24.
//

import SwiftUI

struct CertificateDeductibleView: View {
    @State private var money: String = ""
    @State private var date: Date = Date()
    @State private var keyBoardFocused: Bool = false
    @State private var onTapDatePicker: Bool = false
    @State private var isShowingDatePicker: Bool = false
    @State private var isShowingExpirationAlert: Bool = false
    @State private var isShowingExceedAlert: Bool = false
    @State var certificateDetail: CertificateDetail
    @Environment(HomeStore.self) var homeStore
    @FocusState var focused: Bool
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading) {
                    Text("금액")
                        .font(Font.body03)
                        .foregroundStyle(Color.gray04)
                    CustomTextField(placeholder: "금액을 입력해주세요", keyboardType: .numberPad, text: $money, isFocused: focused)
                        .onChange(of: money) { _, newValue in
                            if Int(newValue) ?? homeStore.certificateDetail.remainingAmount > homeStore.certificateDetail.remainingAmount {
                                money = String(homeStore.certificateDetail.remainingAmount)
                            }
                        }
                }
                .padding(.horizontal, 16)
                
                VStack(alignment: .leading) {
                    Text("받은 날짜")
                        .font(Font.body03)
                        .foregroundStyle(Color.gray04)
                    ZStack(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray08, lineWidth: 1)
                            .fill(Color.gray09)
                            .background(RoundedRectangle(cornerRadius: 6))
                            .foregroundStyle(.white)
                            .frame(height: 45)
                            .overlay(
                                Button {
                                    onTapDatePicker = true
                                    isShowingDatePicker.toggle()
                                } label: {
                                    HStack {
                                        if onTapDatePicker {
                                            Text(date.dateToString())
                                                .font(Font.body02)
                                                .foregroundStyle(.black)
                                        } else {
                                            Text("YY.MM.DD")
                                                .font(Font.body02)
                                                .foregroundStyle(Color.gray07)
                                        }
                                        Spacer()
                                    }
                                }.padding(.leading, 14)
                                , alignment: .leading
                            )
                        Image(systemName: "calendar")
                            .padding(.trailing, 16)
                    }
                }
                .padding(.horizontal, 16)
                VStack(alignment: .leading, spacing: 0) {
                    Text("받은 내역")
                        .font(Font.body03)
                        .foregroundStyle(Color.gray04)
                        .padding(.horizontal, 16)
                    List(certificateDetail.repaymentHistories, id: \.self) { repayment in
                        HStack {
                            Text(repayment.repaymentDate)
                                .font(Font.body01)
                            Spacer()
                            Text("\(repayment.repaymentAmount)원")
                                .font(Font.body04)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 6))
                        .shadow(color: Color.gray05.opacity(0.3), radius: 5)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
                .padding(.top, 20)
                Button {
                        if certificateDetail.remainingAmount >= Int(money) ?? 0 {
                            if !money.isEmpty && money != "0"{
                                self.endTextEditing()
                                homeStore.deductedSave(paperId: certificateDetail.paperId, repaymentDate: date.dateToString(), repaymentAmount: money)
                                certificateDetail.repaymentHistories.append(Deducted(id: 0, repaymentDate: date.dateToString().replacingOccurrences(of: "-", with: "."), repaymentAmount: Int(money) ?? 0))
                                homeStore.certificateDetail.remainingAmount -= Int(money) ?? 0
                                money = ""
                            } else {
                                money = ""
                            }
                        }
                } label: {
                    Text("입력하기")
                        .font(Font.title04)
                        .foregroundStyle(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.payritMint)
                        .clipShape(.rect(cornerRadius: keyBoardFocused ? 0 : 12))
                }
                .padding(.bottom, keyBoardFocused ? 0 : 16)
                .padding(.horizontal, keyBoardFocused ? 0 : 16)
            }
        }
        .dismissOnDrag()
        .onTapGesture { self.endTextEditing() }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { _ in
            keyBoardFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyBoardFocused = false
        }
        .onAppear {
            focused = true
        }
        .navigationTitle("받은 금액 입력하기")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingDatePicker, content: {
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .presentationDetents([.height(400)])
                .tint(Color.payritMint)
        })
    }
}

#Preview {
    NavigationStack {
        CertificateDeductibleView(certificateDetail: CertificateDetail.EmptyCertificate)
            .environment(HomeStore())
    }
}
