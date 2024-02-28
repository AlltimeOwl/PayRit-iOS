//
//  ContentView.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI
import KakaoSDKTemplate
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import AuthenticationServices

struct SignInView: View {
    let url = "testImage.png"
    let singInStore: SignInStore
    @State var test = ""
    @State var logInOK = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                Image("testImage")
                    .resizable()
                    .frame(height: UIScreen.screenHeight)
                Text("페이릿")
                    .font(.santokkiHome)
                    .foregroundStyle(.white)
                
                VStack(spacing: 8) {
                    Spacer()
                    Button {
                        if UserApi.isKakaoTalkLoginAvailable() {
                            UserApi.shared.loginWithKakaoTalk(launchMethod: .CustomScheme) {(oauthToken, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    singInStore.loadingInfoDidKakaoAuth()
                                    logInOK = true
                                }
                            }
                        } else {
                            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                                //                            print(oauthToken)
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    singInStore.loadingInfoDidKakaoAuth()
                                    logInOK = true
                                }
                            }
                        }
                    } label: {
                        Image("kakaoLoginImage")
                    }
                    Button {
                        
                    } label: {
                        Image("appleLoginImage")
                    }
                    .frame(width: UIScreen.screenWidth * 0.9, height: 48)
                    Button {
                        logInOK = true
                    } label: {
                        Text("서비스 둘러보기")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    .frame(height: 48)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 58)
                }
            }
            .ignoresSafeArea(.all)
            .navigationDestination(isPresented: $logInOK) {
                TabBarView()
            }
            .onAppear(perform: {
                
            })
        }
    }
}

#Preview {
    SignInView(singInStore: SignInStore())
}
