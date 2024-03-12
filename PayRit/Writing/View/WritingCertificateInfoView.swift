//
//  WritingCertificateInfoView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

struct WritingCertificateInfoView: View {
    @State private var date = Date()
    @State private var money: String = ""
    @State private var etc: String = ""
    @State private var interest: String = ""
    @State private var calToggle: Bool = false
    @State private var isShowingStopAlert: Bool = false
    @State private var isShowingInterestToastMessage: Bool = false
    @State private var isShowingFormToastMessage: Bool = false
    @State private var moveNextView: Bool = false
    @State private var newCertificate: Certificate = Certificate.EmptyCertificate
    @Binding var certificateType: CertificateType
    @Binding var path: NavigationPath
    @FocusState private var interestFocused: Bool
    var isFormValid: Bool {
        let isBasicInfoValid = !money.isEmpty && !newCertificate.tradeDay.isEmpty && !newCertificate.endDay.isEmpty
            if calToggle {
                return isBasicInfoValid && !interest.isEmpty
            } else {
                return isBasicInfoValid
            }
        }
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("금액")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        ZStack {
                            HStack {
                                if money.count >= 1 {
                                    Text(money + " 원")
                                        .font(Font.body01)
                                        .padding(.horizontal, 14)
                                    Spacer()
                                }
                            }
                            CustomTextField(backgroundColor: .clear, foregroundStyle: .clear, placeholder: "0 원", keyboardType: .numberPad, text: $money, isFocused: interestFocused)
                                .onChange(of: money) {
                                    newCertificate.totalMoney = Int(money) ?? 0
                                }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("송금 날짜")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
//                        CustomTextField(foregroundStyle: .black, placeholder: "YY.MM.DD", keyboardType: .numberPad, text: $newCertificate.tradeDay, isFocused: interestFocused)
//                            .onChange(of: newCertificate.tradeDay) {
//                                
//                            }
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray08, lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 6))
                            .foregroundStyle(.white)
                            .frame(height: 42)
                            .overlay(
                                Text("YY.MM.DD")
                                    .padding(.leading, 14)
                                , alignment: .leading
                            )
                    }
                    
                    VStack(alignment: .leading) {
                        Text("상환 마감일")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        CustomTextField(foregroundStyle: .black, placeholder: "YY.MM.DD", keyboardType: .numberPad, text: $newCertificate.endDay, isFocused: interestFocused)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("특별히 추가할 내용이 있나요? (선택)")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        CustomTextField(foregroundStyle: .black, placeholder: "", keyboardType: .default, text: $etc, isFocused: interestFocused)
                            .onChange(of: etc) {
                                newCertificate.etc? = etc
                            }
                    }
                    
                    HStack {
                        Text("이자 계산기")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        Spacer()
                        Toggle("", isOn: $calToggle)
                            .onTapGesture {
                                if calToggle == false { interest = "" }
                            }
                            .tint(Color.payritMint)
                    }
                    if calToggle {
                        VStack(alignment: .leading) {
                            Text("연 이자율")
                                .font(Font.body03)
                                .foregroundStyle(Color.gray04)
                            ZStack {
                                HStack {
                                    Text(interest + " %")
                                        .font(Font.body01)
                                        .padding(.horizontal, 14)
                                        .foregroundStyle(interest.isEmpty ? .clear : .black)
                                    Spacer()
                                }
                                CustomTextField(backgroundColor: .clear, foregroundStyle: .clear, placeholder: "숫자를 입력해주세요", keyboardType: .decimalPad, text: $interest, isFocused: interestFocused)
                                    .onChange(of: interest) { oldValue, newValue in
                                        if newValue.count < 6 {
                                            if newValue.filter({ $0 == "." }).count >= 2 {
                                                interest = oldValue
                                            } else {
                                                if !interest.isEmpty && interest != "." {
                                                    if Float(newValue) ?? 20.0 >= 20.0 {
                                                        interest = "19.99"
                                                    }
                                                }
                                            }
                                        } else {
                                            interest = oldValue
                                        }
                                        newCertificate.interestRate = Double(interest) ?? 0.0
                                    }
                            }
                            
                            HStack {
                                Text("이자는 20%를 넘어설 수 없어요.")
                                Button {
                                    isShowingInterestToastMessage.toggle()
                                } label: {
                                    Image(systemName: "questionmark.circle")
                                }
                            }
                            .padding(.top, 1)
                            .font(Font.caption01)
                            .foregroundStyle(Color.payritErrorRed)
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
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal, 16)
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
                    .clipShape(.rect(cornerRadius: 12))
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("페이릿 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture { self.endTextEditing() }
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
