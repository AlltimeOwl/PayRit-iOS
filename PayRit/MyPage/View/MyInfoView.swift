//
//  MyInfoView.swift
//  PayRit
//
//  Created by 임대진 on 3/6/24.
//

import SwiftUI

struct MyInfoView: View {
    @Environment(SignInStore.self) var signInStore
    @Environment(TabBarStore.self) var tabStore
    let mypageStore: MyPageStore = MyPageStore()
    
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
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
                                Text(mypageStore.currenUser.name)
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
                                Text(mypageStore.currenUser.email)
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
                                Text(mypageStore.currenUser.phoneNumber)
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
                                Text(mypageStore.currenUser.signInCompany)
                                    .font(Font.body02)
                                    .foregroundStyle(Color.gray06)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        }
                }
                Spacer()
                NavigationLink {
                    MembershipWithdrawalView()
                        .customBackbutton()
                } label: {
                    Text("회원탈퇴")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray).opacity(0.5)
                }
            }
        }
        .dismissOnDrag()
        .navigationTitle("계정 정보")
        .navigationBarTitleDisplayMode(.inline)
        .padding(16)
        .font(.system(size: 16))
        
    }
}

#Preview {
    NavigationStack {
        MyInfoView()
            .environment(SignInStore())
            .environment(TabBarStore())
    }
}
