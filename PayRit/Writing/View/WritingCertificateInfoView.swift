//
//  WritingCertificateInfoView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

struct WritingCertificateInfoView: View {
    @State private var redemptionDate: Date = Date()
    @State private var money: String = ""
    @State private var etc: String = ""
    @State private var interest: String = ""
    @State private var interestDate: String = ""
    @State private var warningMessage: Bool = false
    @State private var calToggle: Bool = false
    @State private var onTapDate: Bool = false
    @State private var isShowingStopAlert: Bool = false
    @State private var isShowingInterestToastMessage: Bool = false
    @State private var isShowingFormToastMessage: Bool = false
    @State private var isShowingDatePicker: Bool = false
    @State private var moveNextView: Bool = false
    @State private var keyBoardFocused: Bool = false
    @State private var newCertificate: Certificate = Certificate.EmptyCertificate
    @Binding var certificateType: CertificateType
    @Binding var path: NavigationPath
    var isFormValid: Bool {
        if calToggle {
            return !money.isEmpty && onTapDate && !interest.isEmpty
        } else {
            return !money.isEmpty && onTapDate
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("금액")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        CustomTextField(placeholder: "금액을 입력해주세요", keyboardType: .numberPad, text: $money, isFocused: keyBoardFocused)
                            .onChange(of: money) {
                                newCertificate.totalMoney = Int(money) ?? 0
                            }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("원금 상환일")
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
                                        onTapDate = true
                                        isShowingDatePicker.toggle()
                                    } label: {
                                        if onTapDate {
                                            Text(redemptionDate.dateToString())
                                                .font(Font.body02)
                                                .foregroundStyle(.black)
                                        } else {
                                            Text("YY.MM.DD")
                                                .font(Font.body02)
                                                .foregroundStyle(Color.gray07)
                                        }
                                    }
                                }
                                    .padding(.leading, 14)
                                , alignment: .leading
                            )
                    }
                    
                    VStack(alignment: .leading) {
                        Text("특별히 추가할 내용이 있나요? (선택)")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        CustomTextField(foregroundStyle: .black, placeholder: "특별히 추가할 내용을 적어주세요", keyboardType: .default, text: $etc, isFocused: keyBoardFocused)
                            .onChange(of: etc) {
                                newCertificate.etc? = etc
                            }
                    }
                    VStack(spacing: 0) {
                        if !calToggle {
                            HStack {
                                Text("이자 계산")
                                    .font(.system(size: 16))
                                    .fontWeight(.semibold)
                                Spacer()
                                Toggle("", isOn: $calToggle)
                                    .onTapGesture {
                                        if calToggle == false { interest = "" }
                                    }
                                    .tint(Color.payritMint)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.payritMint, lineWidth: 2)
                                    .background(Color(hex: "E5FDFC"))
                            )
                        } else {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text("이자 계산")
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Toggle("", isOn: $calToggle)
                                        .onTapGesture {
                                            if calToggle == false { interest = "" }
                                        }
                                        .tint(Color.payritMint)
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(
                                    Rectangle()
                                        .foregroundStyle(Color(hex: "E5FDFC"))
                                )
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("연 이자율")
                                        .font(Font.body03)
                                        .foregroundStyle(Color.gray04)
                                    HStack {
                                        Image(systemName: "info.circle")
                                        Text("한 달은 30일, 일 년은 365일로 계산된 기준입니다.")
                                    }
                                    .padding(.top, 4)
                                    .font(Font.caption03)
                                    .foregroundStyle(Color.gray04)
                                    
                                    CustomTextField(placeholder: "숫자를 입력해주세요", keyboardType: .decimalPad, text: $interest, isFocused: keyBoardFocused)
                                        .onChange(of: interest) { oldValue, newValue in
                                            if newValue.count < 6 {
                                                if newValue.filter({ $0 == "." }).count >= 2 {
                                                    interest = oldValue
                                                } else {
                                                    if !interest.isEmpty && interest != "." {
                                                        if Float(newValue) ?? 20.0 >= 20.0 {
                                                            interest = "19.99"
                                                            warningMessage = true
                                                        }
                                                    }
                                                }
                                            } else {
                                                interest = oldValue
                                            }
                                            newCertificate.interestRate = Double(interest) ?? 0.0
                                        }
                                    .padding(.top, 4)
                                    
                                    if warningMessage {
                                        HStack {
                                            Text("이자는 20%를 넘어설 수 없어요.")
                                            Button {
                                                isShowingInterestToastMessage.toggle()
                                            } label: {
                                                Image(systemName: "questionmark.circle")
                                            }
                                        }
                                        .font(Font.caption01)
                                        .foregroundStyle(Color.payritErrorRed)
                                        .padding(.top, 4)
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Text("지급해야하는 이자는 약 ")
                                        Text("\(newCertificate.totalAmount - newCertificate.totalMoney)")
                                            .foregroundStyle(Color.payritMint)
                                        Text("원이에요")
                                    }
                                    .padding(.vertical, 20)
                                    .font(Font.body02)
                                    
                                    Text("이자 지급일(선택)")
                                        .font(Font.body03)
                                        .foregroundStyle(Color.gray04)
                                    CustomTextField(placeholder: "숫자를 입력해주세요", keyboardType: .numberPad, text: $interestDate, isFocused: keyBoardFocused)
                                        .onChange(of: interestDate) { _, _ in
                                            newCertificate.interestRateDay = interestDate
                                        }
                                    .padding(.top, 4)
                                }
                                .padding(16)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.payritMint, lineWidth: 2)
                            )
                        }
                    }
                    if !money.isEmpty {
                        HStack(spacing: 0) {
                            Text("총 ")
                            if calToggle {
                                Text("\(newCertificate.totalAmountFormatter)")
                                    .foregroundStyle(Color.payritMint)
                            } else {
                                Text(newCertificate.totalMoneyFormatter)
                                    .foregroundStyle(Color.payritMint)
                            }
                            Text("원을 상환해야해요!")
                        }
                        .font(Font.title04)
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            
            Button {
                if !isFormValid {
                    isShowingFormToastMessage.toggle()
                } else {
                    moveNextView.toggle()
                }
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
        }
        .scrollIndicators(.hidden)
        .navigationTitle("페이릿 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture { self.endTextEditing() }
        .onChange(of: keyBoardFocused) {
            print(keyBoardFocused)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { _ in
            keyBoardFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyBoardFocused = false
        }
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
        .sheet(isPresented: $isShowingDatePicker, content: {
            DatePicker("", selection: $redemptionDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .presentationDetents([.height(400)])
        })
        .onChange(of: redemptionDate) {
            newCertificate.redemptionDate = redemptionDate.dateToString()
        }
        .PrimaryAlert(isPresented: $isShowingStopAlert,
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
        .toast(isShowing: $isShowingInterestToastMessage, message: "이자제한법상 법정 최고 이자율은 20% 미만 입니다.")
        .toast(isShowing: $isShowingFormToastMessage, message: "필수 항목을 작성해주세요")
        .navigationDestination(isPresented: $moveNextView) {
            MyInfoWritingView(newCertificate: $newCertificate, path: $path)
                .customBackbutton()
        }
        .onAppear {
            newCertificate.type = certificateType
        }
    }
}

#Preview {
    TabView {
        NavigationStack {
            WritingCertificateInfoView(certificateType: .constant(.iBorrowed), path: .constant(NavigationPath()))
        }
    }
}
