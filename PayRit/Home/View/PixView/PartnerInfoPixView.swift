//
//  DebtorPixView.swift
//  PayRit
//
//  Created by 임대진 on 4/21/24.
//

import SwiftUI

struct PartnerInfoPixView: View {
    let writingStore: WritingStore
    var isFormValid: Bool {
        if !name.isEmpty && !phoneNumber.isEmpty {
            return true
        } else {
            return false
        }
    }
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var zipCode = ""
    @State private var address = ""
    @State private var detailAddress = ""
    @State private var moveNextView: Bool = false
    @State private var notEnoughPhoneNumberLength: Bool = false
    @State private var isPresentingZipCodeView: Bool = false
    @State private var isShowingStopAlert: Bool = false
    @State private var keyBoardFocused: Bool = false
    @Binding var newCertificate: CertificateDetail
    @Binding var path: NavigationPath
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        VStack {
                            Text("""
                                 상대방의
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
                                    if newCertificate.memberRole == "DEBTOR" {
                                        newCertificate.creditorProfile.name = name
                                    } else if newCertificate.memberRole == "CREDITOR" {
                                        newCertificate.debtorProfile.name = name
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
                                        if newCertificate.memberRole == "DEBTOR" {
                                            newCertificate.creditorProfile.phoneNumber = phoneNumber
                                        } else if newCertificate.memberRole == "CREDITOR" {
                                            newCertificate.debtorProfile.phoneNumber = phoneNumber
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
                                    .disabled(true)
                                    .onChange(of: zipCode) {
                                        if newCertificate.memberRole == "DEBTOR" {
                                            newCertificate.creditorProfile.address = address + "(\(zipCode))"
                                        } else if newCertificate.memberRole == "CREDITOR" {
                                            newCertificate.debtorProfile.address = address + "(\(zipCode))"
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
                                    if newCertificate.memberRole == "DEBTOR" {
                                        newCertificate.creditorProfile.address = address + " \(detailAddress) " + "(\(zipCode))"
                                    } else if newCertificate.memberRole == "CREDITOR" {
                                        newCertificate.debtorProfile.address = address + " \(detailAddress) " + "(\(zipCode))"
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
                if newCertificate.memberRole == "DEBTOR" {
                    self.name = newCertificate.creditorProfile.name
                    self.phoneNumber = newCertificate.creditorProfile.phoneNumber
                    self.address = newCertificate.creditorProfile.address
                } else if newCertificate.memberRole == "CREDITOR" {
                    self.name = newCertificate.debtorProfile.name
                    self.phoneNumber = newCertificate.debtorProfile.phoneNumber
                    self.address = newCertificate.debtorProfile.address
                }
            }
            .sheet(isPresented: $isPresentingZipCodeView) {
                KakaoAdressView(address: $address, zonecode: $zipCode, isPresented: $isPresentingZipCodeView)
                    .edgesIgnoringSafeArea(.all)
            }
            .primaryAlert(isPresented: $isShowingStopAlert,
                          title: "작성 중단",
                          content: """
                            수정을 종료하시겠습니까?
                            """,
                          primaryButtonTitle: "아니오",
                          cancleButtonTitle: "네") {
            } cancleAction: {
                path = .init()
            }
            .navigationDestination(isPresented: $moveNextView) {
                WritingCheckView(saveType: SaveInfo(type: .pix, id: newCertificate.paperId), writingStore: writingStore, path: $path, newCertificate: $newCertificate)
                    .customBackbutton()
            }
        }
    }
}
