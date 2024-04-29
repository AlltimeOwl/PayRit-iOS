//
//  CardInfoView.swift
//  PayRit
//
//  Created by 임대진 on 4/21/24.
//

import SwiftUI

struct CardInfoView: View {
    let contacts: [Contacts]
    @State private var money: String = ""
    @State private var onTapBorrowedDate: Bool = false
    @State private var onTapRedemptionDate: Bool = false
    @State private var isShowingStopAlert = false
    @State private var isShowingBorrowedDatePicker: Bool = false
    @State private var isShowingRedemptionDatePicker: Bool = false
    @State private var keyBoardFocused: Bool = false
    @Binding var promise: Promise
    @Binding var path: NavigationPath
    
    var isFormValid: Bool {
        return !String(promise.amount).isEmpty && onTapBorrowedDate && onTapRedemptionDate && !promise.contents.isEmpty
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("약속 카드에 대한 정보를\n입력해주세요")
                        .font(Font.title03)
                        .frame(height: 60)
                    
                    VStack(alignment: .leading) {
                        Text("얼마를 약속했나요?")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        CustomTextField(placeholder: "금액을 입력해주세요", keyboardType: .numberPad, text: $money)
                            .onChange(of: money) { _, _ in
                                promise.amount = Int(money) ?? 0
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
                                                Text(promise.promiseStartDate.hyphenFomatter())
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
                                                Text(promise.promiseEndDate.hyphenFomatter())
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
                        
                        TextEditor(text: $promise.contents)
                            .font(Font.body02)
                            .foregroundStyle(.black)
                            .background(Color.gray09)
                            .scrollContentBackground(.hidden)
                            .clipShape(.rect(cornerRadius: 6))
                            .frame(height: 180)
                            .shadow(color: .gray.opacity(0.2), radius: 2)
                            .overlay(alignment: .topLeading) {
                                if promise.contents.isEmpty {
                                    Text("ex) 우육면 12000원")
                                        .font(Font.body02)
                                        .foregroundStyle(Color.gray07)
                                        .padding(.top, 10)
                                        .padding(.leading, 14)
                                }
                            }
                    }
                }
            }
            .padding(.top, 30)
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
            
            NavigationLink {
                PromiseCheckView(contacts: contacts, promise: promise, path: $path)
                    .customBackbutton()
            } label: {
                Text("다음")
                    .font(Font.title04)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(!isFormValid ? Color.gray07 : Color.payritMint)
                    .clipShape(.rect(cornerRadius: keyBoardFocused ? 0 : 12))
            }
            .padding(.bottom, keyBoardFocused ? 0 : 16)
            .padding(.horizontal, keyBoardFocused ? 0 : 16)
            .disabled(!isFormValid)
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .navigationTitle("약속 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingBorrowedDatePicker, content: {
            DatePicker("", selection: $promise.promiseStartDate, in: Date()..., displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .presentationDetents([.height(400)])
                .onDisappear {
                }
        })
        .sheet(isPresented: $isShowingRedemptionDatePicker, content: {
            DatePicker("", selection: $promise.promiseEndDate, in: promise.promiseStartDate..., displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .presentationDetents([.height(400)])
                .onDisappear {
                }
        })
        .toolbar {
            ToolbarItem {
                Button {
                    isShowingStopAlert.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { _ in
            keyBoardFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyBoardFocused = false
        }
        .primaryAlert(isPresented: $isShowingStopAlert,
                      title: "작성 중단",
                      content: """
                        지금 작성을 중단하시면
                        처음부터 다시 작성해야해요.
                        작성 전 페이지로 돌아갈까요?
                        """,
                      primaryButtonTitle: "아니오",
                      cancleButtonTitle: "네") {
        } cancleAction: {
            path = .init()
        }
    }
}

#Preview {
    CardInfoView(contacts: [Contacts(name: "", phoneNumber: "")], promise: .constant(Promise(promiseId: 0, amount: 0, promiseStartDate: Date(), promiseEndDate: Date(), writerName: "", contents: "", participants: [Participants](), promiseImageType: .PRESENT)), path: .constant(NavigationPath()))
}
