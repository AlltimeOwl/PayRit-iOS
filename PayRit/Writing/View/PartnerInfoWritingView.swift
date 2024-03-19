//
//  PartnerInfoWritingView.swift
//  PayRit
//
//  Created by 임대진 on 3/5/24.
//

import SwiftUI
import UIKit

struct PartnerInfoWritingView: View {
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var zipCode = ""
    @State private var address = ""
    @State private var detailAddress = ""
    @State private var isPresentingZipCodeView = false
    @State private var isShowingStopAlert = false
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
                                    switch newCertificate.writerRole {
                                    case .DEBTOR
                                        : newCertificate.creditorName = name
                                    case .CREDITOR
                                        : newCertificate.debtorName = name
                                    }
                                }
                        }
                        VStack(alignment: .leading) {
                            Text("연락처")
                                .font(Font.body03)
                            CustomTextField(foregroundStyle: .black, placeholder: "숫자만 입력해주세요", keyboardType: .numberPad, text: $phoneNumber)
                                .onChange(of: phoneNumber) {
                                    switch newCertificate.writerRole {
                                    case .DEBTOR
                                        : newCertificate.creditorPhoneNumber = writingStore.phoneNumberFormatter(number: phoneNumber)
                                    case .CREDITOR
                                        : newCertificate.debtorPhoneNumber = writingStore.phoneNumberFormatter(number: phoneNumber)
                                    }
                                }
                            
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("주소 (선택사항)")
                                .font(Font.body03)
                            HStack(alignment: .bottom) {
                                CustomTextField(foregroundStyle: .black, placeholder: "우편번호", keyboardType: .numberPad, text: $zipCode)
                                    .disabled(true)
                                    .onChange(of: zipCode) {
                                        switch newCertificate.writerRole {
                                        case .DEBTOR
                                            : newCertificate.debtorAddress = address + "(\(zipCode))"
                                        case .CREDITOR
                                            : newCertificate.creditorAddress = address + "(\(zipCode))"
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
                                    switch newCertificate.writerRole {
                                    case .DEBTOR
                                        : newCertificate.debtorAddress = address + " \(detailAddress) " + "(\(zipCode))"
                                    case .CREDITOR
                                        : newCertificate.creditorAddress = address + " \(detailAddress) " + "(\(zipCode))"
                                    }
                                }
                        }
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 16)
                }
                NavigationLink {
                    WritingCheckView(path: $path, newCertificate: $newCertificate)
                        .customBackbutton()
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
        .onAppear {
            print(newCertificate)
        }
    }
}

#Preview {
    NavigationStack {
        PartnerInfoWritingView(newCertificate: .constant(CertificateDetail.EmptyCertificate), path: .constant(NavigationPath()))
    }
}

