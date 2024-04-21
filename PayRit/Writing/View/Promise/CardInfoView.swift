//
//  CardInfoView.swift
//  PayRit
//
//  Created by 임대진 on 4/21/24.
//

import SwiftUI

struct CardInfoView: View {
    @State private var money: String = ""
    @State private var content: String = ""
    @State private var repaymentStartDate: Date = Date()
    @State private var repaymentEndDate: Date = Date()
    @State private var onTapBorrowedDate: Bool = false
    @State private var onTapRedemptionDate: Bool = false
    @State private var isShowingBorrowedDatePicker: Bool = false
    @State private var isShowingRedemptionDatePicker: Bool = false
    @Binding var path: NavigationPath
    var isFormValid: Bool {
        return !money.isEmpty && onTapBorrowedDate && onTapRedemptionDate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("약속 카드에 대한 정보를\n입력해주세요")
                .font(Font.title03)
            VStack(alignment: .leading) {
                Text("얼마를 약속했나요?")
                    .font(Font.body03)
                    .foregroundStyle(Color.gray04)
                CustomTextField(placeholder: "금액을 입력해주세요", keyboardType: .numberPad, text: $money)
                    .onChange(of: money) { _, _ in
//                        if let money = Int(money) {
//                        }
                    }
            }
            
            VStack(alignment: .leading) {
                Text("언제 약속했나요?")
                    .font(Font.body03)
                    .foregroundStyle(Color.gray04)
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray08, lineWidth: 1)
                    .fill(Color.gray09)
                    .background(RoundedRectangle(cornerRadius: 6))
                    .foregroundStyle(.white)
                    .frame(height: 45)
                    .overlay(
                        VStack {
                            Button {
                                endTextEditing()
                                onTapBorrowedDate = true
                                isShowingBorrowedDatePicker.toggle()
                            } label: {
                                HStack {
                                    if onTapBorrowedDate {
                                        Text(repaymentStartDate.dateToString())
                                            .font(Font.body02)
                                            .foregroundStyle(.black)
                                    } else {
                                        Text("날짜를 입력해 주세요")
                                            .font(Font.body02)
                                            .foregroundStyle(Color.gray07)
                                    }
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .font(.system(size: 20))
                                        .foregroundStyle(Color.gray06)
                                }
                            }
                        }
                            .padding(.horizontal, 14)
                        , alignment: .leading
                    )
            }
            
            VStack(alignment: .leading) {
                Text("언제까지 약속했나요?")
                    .font(Font.body03)
                    .foregroundStyle(Color.gray04)
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray08, lineWidth: 1)
                    .fill(Color.gray09)
                    .background(RoundedRectangle(cornerRadius: 6))
                    .foregroundStyle(.white)
                    .frame(height: 45)
                    .overlay(
                        VStack {
                            Button {
                                endTextEditing()
                                onTapRedemptionDate = true
                                isShowingRedemptionDatePicker.toggle()
                            } label: {
                                HStack {
                                    if onTapRedemptionDate {
                                        Text(repaymentEndDate.dateToString())
                                            .font(Font.body02)
                                            .foregroundStyle(.black)
                                    } else {
                                        Text("날짜를 입력해 주세요")
                                            .font(Font.body02)
                                            .foregroundStyle(Color.gray07)
                                    }
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .font(.system(size: 20))
                                        .foregroundStyle(Color.gray06)
                                }
                            }
                        }
                            .padding(.horizontal, 14)
                        , alignment: .leading
                    )
            }
            
            VStack(alignment: .leading) {
                Text("약속 내용")
                    .font(Font.body03)
                    .foregroundStyle(Color.gray04)
                
                TextEditor(text: $content)
                    .font(Font.body02)
                    .foregroundStyle(.black)
                    .background(Color.gray09)
                    .scrollContentBackground(.hidden)
                    .clipShape(.rect(cornerRadius: 6))
                    .frame(height: 180)
                    .shadow(color: .gray.opacity(0.2), radius: 2)
                    .overlay(alignment: .topLeading) {
                        if content.isEmpty {
                            Text("ex) 우육면 12000원")
                                .font(Font.body02)
                                .foregroundStyle(Color.gray07)
                                .padding(.top, 10)
                                .padding(.leading, 14)
                        }
                    }
            }
            Spacer()
            NavigationLink {
                PromiseCheckView(path: $path)
            } label: {
                Text("다음")
//                    .font(Font.title04)
//                    .foregroundStyle(.white)
//                    .frame(height: 50)
//                    .frame(maxWidth: .infinity)
//                    .background(!isFormValid ? Color.gray07 : Color.payritMint)
//                    .clipShape(.rect(cornerRadius: keyBoardFocused ? 0 : 12))
//                    .disabled(!isFormValid)
            }
//            .padding(.bottom, keyBoardFocused ? 0 : 16)
//            .padding(.horizontal, keyBoardFocused ? 0 : 16)
        }
        .padding(.top, 30)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .sheet(isPresented: $isShowingBorrowedDatePicker, content: {
            DatePicker("", selection: $repaymentStartDate, in: Date()..., displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .presentationDetents([.height(400)])
                .onDisappear {
                }
        })
        .sheet(isPresented: $isShowingRedemptionDatePicker, content: {
            DatePicker("", selection: $repaymentEndDate, in: repaymentStartDate..., displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .presentationDetents([.height(400)])
                .onDisappear {
                }
        })
        .onChange(of: repaymentStartDate) {
        }
        .onChange(of: repaymentEndDate) {
        }
        .toolbar {
            ToolbarItem {
                Button {
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    CardInfoView(path: .constant(NavigationPath()))
}
