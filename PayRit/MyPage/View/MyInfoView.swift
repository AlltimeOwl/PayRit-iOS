//
//  MyInfoView.swift
//  PayRit
//
//  Created by 임대진 on 3/6/24.
//

import SwiftUI

struct MyInfoView: View {
    let sampleUser = User.sampleUser
    @Binding var tabBarVisivility: Visibility
    @Binding var signInStore: SignInStore
    var body: some View {
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
                            Text(sampleUser.name)
                                .font(Font.body02)
                                .foregroundStyle(Color.gray06)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
            }
            VStack(alignment: .leading) {
                Text("이메일")
                    .font(Font.body02)
                    .foregroundStyle(Color.gray03)
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 48)
                    .foregroundStyle(Color.gray09)
                    .overlay {
                        HStack {
                            Text(sampleUser.email)
                                .font(Font.body02)
                                .foregroundStyle(Color.gray06)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
            }
            VStack(alignment: .leading) {
                Text("이름")
                    .font(Font.body02)
                    .foregroundStyle(Color.gray03)
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 48)
                    .foregroundStyle(Color.gray09)
                    .overlay {
                        HStack {
                            Text(sampleUser.phoneNumber)
                                .font(Font.body02)
                                .foregroundStyle(Color.gray06)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
            }
            VStack(alignment: .leading) {
                Text("연결된 계정")
                    .font(Font.body02)
                    .foregroundStyle(Color.gray03)
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 48)
                    .foregroundStyle(Color.gray09)
                    .overlay {
                        HStack {
                            Text("카카오톡")
                                .font(Font.body02)
                                .foregroundStyle(Color.gray06)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
            }
            Spacer()
            NavigationLink {
                MembershipWithdrawalView(signInStore: $signInStore)
                    .customBackbutton()
            } label: {
                Text("회원탈퇴")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray).opacity(0.5)
            }
        }
        .navigationTitle("계정 정보")
        .navigationBarTitleDisplayMode(.inline)
        .padding(16)
        .font(.system(size: 16))
        .onAppear {
            tabBarVisivility = .hidden
        }

    }
}

#Preview {
    NavigationStack {
        MyInfoView(tabBarVisivility: .constant(.hidden), signInStore: .constant(SignInStore()))
    }
}
