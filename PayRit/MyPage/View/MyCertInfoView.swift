//
//  MyCertInfoView.swift
//  PayRit
//
//  Created by 임대진 on 4/10/24.
//

import SwiftUI

struct MyCertInfoView: View {
    @Environment(MyPageStore.self) var mypageStore
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            if let userCertInfo = mypageStore.userCertInfo {
                VStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("이름")
                            .font(Font.body02)
                            .foregroundStyle(Color.gray03)
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 48)
                            .foregroundStyle(Color.gray09)
                            .overlay {
                                HStack {
                                    Text(userCertInfo.certificationName)
                                        .font(Font.body02)
                                        .foregroundStyle(Color.gray06)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            }
                    }
                    VStack(alignment: .leading) {
                        Text("성별")
                            .font(Font.body02)
                            .foregroundStyle(Color.gray03)
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 48)
                            .foregroundStyle(Color.gray09)
                            .overlay {
                                HStack {
                                    Text(userCertInfo.certificationGender)
                                        .font(Font.body02)
                                        .foregroundStyle(Color.gray06)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            }
                    }
                    VStack(alignment: .leading) {
                        Text("생년월일")
                            .font(Font.body02)
                            .foregroundStyle(Color.gray03)
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 48)
                            .foregroundStyle(Color.gray09)
                            .overlay {
                                HStack {
                                    Text(userCertInfo.certificationBirthday)
                                        .font(Font.body02)
                                        .foregroundStyle(Color.gray06)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            }
                    }
                    VStack(alignment: .leading) {
                        Text("휴대폰 번호")
                            .font(Font.body02)
                            .foregroundStyle(Color.gray03)
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 48)
                            .foregroundStyle(Color.gray09)
                            .overlay {
                                HStack {
                                    Text(userCertInfo.certificationPhoneNumber)
                                        .font(Font.body02)
                                        .foregroundStyle(Color.gray06)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            }
                    }
                    Spacer()
                }
            }
        }
        .dismissOnDrag()
        .navigationTitle("인증 정보")
        .navigationBarTitleDisplayMode(.inline)
        .padding(16)
        .font(.system(size: 16))
        .onAppear {
            mypageStore.loadCertInfo()
        }
    }
}

#Preview {
    NavigationStack {
        MyCertInfoView()
            .environment(MyPageStore())
    }
}
