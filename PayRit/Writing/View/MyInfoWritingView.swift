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
    @State private var isPresentingZipCodeView = false
    @State private var isShowingStopAlert = false
    @Binding var newCertificate: Certificate
    @Binding var path: NavigationPath
    @FocusState var interestFocused: Bool
    var body: some View {
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
                        CustomTextField(foregroundStyle: .black, placeholder: "이름을 적어주세요", keyboardType: .default, text: $name, isFocused: interestFocused)
                    }
                    VStack(alignment: .leading) {
                        Text("연락처")
                        CustomTextField(foregroundStyle: .black, placeholder: "숫자만 입력해주세요", keyboardType: .numberPad, text: $phoneNumber, isFocused: interestFocused)
                        
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("주소")
                        HStack(alignment: .bottom) {
                            CustomTextField(foregroundStyle: .black, placeholder: "우편번호", keyboardType: .numberPad, text: $zipCode, isFocused: interestFocused)
                                .disabled(true)
                            Button {
                                isPresentingZipCodeView.toggle()
                            } label: {
                                Text("우편번호 검색")
                                    .font(Font.body04)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 24)
                                    .frame(height: 42)
                                    .background(Color.gray05)
                                    .clipShape(.rect(cornerRadius: 6))
                            }
                        }
                        CustomTextField(foregroundStyle: .black, placeholder: "", keyboardType: .numberPad, text: $address, isFocused: interestFocused)
                            .disabled(true)
                        CustomTextField(foregroundStyle: .black, placeholder: "상세주소를 적어주세요", keyboardType: .default, text: $detailAddress, isFocused: interestFocused)
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal, 16)
            }
            NavigationLink {
                PartnerInfoWritingView(path: $path)
                    .customBackbutton()
            } label: {
                Text("다음")
                    .font(Font.title04)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.payritMint)
                    .clipShape(.rect(cornerRadius: 12))
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
        }
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
        MyInfoWritingView(newCertificate: .constant(Certificate.EmptyCertificate), path: .constant(NavigationPath()))
    }
}
