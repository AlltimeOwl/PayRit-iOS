//
//  MyPageView.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import SwiftUI

struct MyPageView: View {
    let signInStore = SignInStore()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("이메일 : ")
                    Text(signInStore.userEmail)
                }
                HStack {
                    Text("닉네임 : ")
                    Text(signInStore.userNickname)
                }
                HStack {
                    Text("이름 : ")
                    Text(signInStore.userName)
                }
                HStack {
                    Text("전화번호 : ")
                    Text(signInStore.userPhoneNumber)
                }
                HStack {
                    Text("토큰 : ")
                    Text(signInStore.aToken)
                }
                HStack {
                    Text("토큰 : ")
                    Text(signInStore.rToken)
                }
            }
            VStack {
                NavigationLink {
                    SignInView(singInStore: signInStore)
                } label: {
                    Text("로그인")
                        .foregroundStyle(.black)
                        .frame(width: 100, height: 30)
                        .background(.yellow)
                        .clipShape(.capsule)
                }
                
                Button {
                    signInStore.kakaoSingOut()
                } label: {
                    Text("로그아웃")
                        .foregroundStyle(.black)
                        .frame(width: 100, height: 30)
                        .background(.yellow)
                        .clipShape(.capsule)
                }
                Button {
                    //                  // Inform user and obtain consent
                    //                    guard let withdrawalURL = URL(string: "https://accounts.kakao.com/settings/withdrawal") else {
                    //                      print("Error creating withdrawal URL")
                    //                      return
                    //                    }
                    //                    UIApplication.shared.open(withdrawalURL)
                    signInStore.kakaoUnlink()
                } label: {
                    Text("탈퇴")
                        .foregroundStyle(.black)
                        .frame(width: 100, height: 30)
                        .background(.yellow)
                        .clipShape(.capsule)
                }
                
            }
            .padding(.top, 100)
        }
        //        .navigationDestination(isPresented: <#T##Binding<Bool>#>, destination: <#T##() -> View#>)
    }
}

#Preview {
    NavigationStack {
        MyPageView()
    }
}
