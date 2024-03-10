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
    @Binding var signInState: Bool
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("이름")
                    .bold()
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 48)
//                    .foregroundStyle(Color.semiGrayColor3)
                    .overlay {
                        HStack {
                            Text(sampleUser.name)
//                                .foregroundStyle(Color.semiGrayColor1)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
            }
            VStack(alignment: .leading) {
                Text("이메일")
                    .bold()
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 48)
//                    .foregroundStyle(Color.semiGrayColor3)
                    .overlay {
                        HStack {
                            Text(sampleUser.email)
//                                .foregroundStyle(Color.semiGrayColor1)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
            }
            VStack(alignment: .leading) {
                Text("이름")
                    .bold()
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 48)
//                    .foregroundStyle(Color.semiGrayColor3)
                    .overlay {
                        HStack {
                            Text(sampleUser.phoneNumber)
//                                .foregroundStyle(Color.semiGrayColor1)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
            }
            VStack(alignment: .leading) {
                Text("연결된 계정")
                    .bold()
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 48)
//                    .foregroundStyle(Color.semiGrayColor3)
                    .overlay {
                        HStack {
                            Text("카카오톡")
//                                .foregroundStyle(Color.semiGrayColor1)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
            }
            Spacer()
            NavigationLink {
                MembershipWithdrawalView(signInState: $signInState)
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
        MyInfoView(tabBarVisivility: .constant(.hidden), signInState: .constant(true))
    }
}
