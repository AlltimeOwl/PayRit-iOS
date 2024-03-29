//
//  MyInfoWritingView.swift
//  PayRit
//
//  Created by 임대진 on 3/5/24.
//

import SwiftUI

struct MyInfoWritingView: View {
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var zipCode = ""
    @State private var address = ""
    @State private var detailAddress = ""
    @State private var moveNextView: Bool = false
    @State private var isPresentingZipCodeView = false
    @State private var isShowingStopAlert = false
    @State private var notEnoughPhoneNumberLength: Bool = false
    @State private var keyBoardFocused: Bool = false
    @Binding var newCertificate: CertificateDetail
    @Binding var path: NavigationPath
    let writingStore = WritingStore()
    var isFormValid: Bool {
        if !name.isEmpty && !phoneNumber.isEmpty {
            return true
        } else {
            return false
        }
    }
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        VStack {
                            Text("""
                                 작성하는 분의
                                 정보를 입력해 주세요.
                                """)
                            .font(Font.title03)
                            .lineSpacing(4)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("이름")
                                .font(Font.body03)
                            CustomTextField(foregroundStyle: .black, placeholder: "이름을 적어주세요", keyboardType: .default, text: $name)
                                .onChange(of: name) {
                                    if newCertificate.memberRole == "CREDITOR" {
                                        newCertificate.creditorName = name
                                    } else if newCertificate.memberRole == "DEBTOR" {
                                        newCertificate.debtorName = name
                                    }
                                }
                        }
                        VStack(alignment: .leading) {
                            Text("연락처")
                                .font(Font.body03)
                            CustomTextField(foregroundStyle: .black, placeholder: "숫자만 입력해주세요", keyboardType: .numberPad, text: $phoneNumber)
                                .onChange(of: phoneNumber) { oldValue, newValue in
                                    if newValue.count <= 13 {
                                        phoneNumber = phoneNumber.phoneNumberMiddleCase()
                                        if newCertificate.memberRole == "CREDITOR" {
                                            newCertificate.creditorPhoneNumber = phoneNumber.globalPhoneNumber()
                                        } else if newCertificate.memberRole == "DEBTOR" {
                                            newCertificate.debtorPhoneNumber = phoneNumber.globalPhoneNumber()
                                        }
                                    } else {
                                        phoneNumber = oldValue
                                    }
                                }
                            if notEnoughPhoneNumberLength {
                                Text("전화번호를 확인해주세요")
                                    .font(Font.caption01)
                                    .foregroundStyle(Color.payritErrorRed)
                            }
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("주소 (선택사항)")
                                .font(Font.body03)
                            HStack(alignment: .bottom) {
                                CustomTextField(foregroundStyle: .black, placeholder: "우편번호", keyboardType: .numberPad, text: $zipCode)
                                    .onChange(of: zipCode) {
                                        if newCertificate.memberRole == "CREDITOR" {
                                            newCertificate.creditorAddress = address + "(\(zipCode))"
                                        } else if newCertificate.memberRole == "DEBTOR" {
                                            newCertificate.debtorAddress = address + "(\(zipCode))"
                                        }
                                    }
                                Button {
                                    isPresentingZipCodeView.toggle()
                                } label: {
                                    Text("우편번호 검색")
                                        .font(Font.body04)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 24)
                                        .frame(height: 45)
                                        .background(Color.gray05)
                                        .clipShape(.rect(cornerRadius: 6))
                                }
                            }
                            CustomTextField(foregroundStyle: .black, placeholder: "", keyboardType: .numberPad, text: $address)
                                .disabled(true)
                            CustomTextField(foregroundStyle: .black, placeholder: "상세주소를 적어주세요", keyboardType: .default, text: $detailAddress)
                                .onChange(of: detailAddress) {
                                    if newCertificate.memberRole == "CREDITOR" {
                                        newCertificate.creditorAddress = address + " \(detailAddress) " + "(\(zipCode))"
                                    } else if newCertificate.memberRole == "DEBTOR" {
                                        newCertificate.debtorAddress = address + " \(detailAddress) " + "(\(zipCode))"
                                    }
                                }
                        }
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 16)
                }
                Button {
                    if phoneNumber.count < 13 {
                        notEnoughPhoneNumberLength = true
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
                        .disabled(!isFormValid)
                }
                .padding(.bottom, keyBoardFocused ? 0 : 16)
                .padding(.horizontal, keyBoardFocused ? 0 : 16)
                
            }
        }
        .dismissOnDrag()
        .navigationTitle("페이릿 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture { self.endTextEditing() }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { _ in
            keyBoardFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyBoardFocused = false
        }
        .onAppear {
            
            if UserDefaultsManager().getUserInfo().signInCompany == "애플" {
                let userDefault = UserDefaultsManager().getAppleUserInfo()
                if newCertificate.memberRole == "CREDITOR" {
                    newCertificate.creditorName = userDefault.name
                    newCertificate.creditorPhoneNumber = userDefault.phoneNumber
                    self.name = userDefault.name
                    self.phoneNumber = userDefault.phoneNumber.onlyPhoneNumber()
                } else if newCertificate.memberRole == "DEBTOR" {
                    newCertificate.debtorName = userDefault.name
                    newCertificate.debtorPhoneNumber = userDefault.phoneNumber
                    self.name = userDefault.name
                    self.phoneNumber = userDefault.phoneNumber.onlyPhoneNumber()
                }
            } else {
                let userDefault = UserDefaultsManager().getUserInfo()
                if newCertificate.memberRole == "CREDITOR" {
                    newCertificate.creditorName = userDefault.name
                    newCertificate.creditorPhoneNumber = userDefault.phoneNumber
                    self.name = userDefault.name
                    self.phoneNumber = userDefault.phoneNumber.onlyPhoneNumber()
                } else if newCertificate.memberRole == "DEBTOR" {
                    newCertificate.debtorName = userDefault.name
                    newCertificate.debtorPhoneNumber = userDefault.phoneNumber
                    self.name = userDefault.name
                    self.phoneNumber = userDefault.phoneNumber.onlyPhoneNumber()
                }
            }
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
        .sheet(isPresented: $isPresentingZipCodeView) {
            KakaoAdressView(address: $address, zonecode: $zipCode, isPresented: $isPresentingZipCodeView)
                .edgesIgnoringSafeArea(.all)
        }
        .navigationDestination(isPresented: $moveNextView) {
            PartnerInfoWritingView(newCertificate: $newCertificate, path: $path)
                .customBackbutton()
        }
    }
}

#Preview {
    NavigationStack {
        MyInfoWritingView(newCertificate: .constant(CertificateDetail.EmptyCertificate), path: .constant(NavigationPath()))
    }
}
