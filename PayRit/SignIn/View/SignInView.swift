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
    let singInStore: SignInStore
    @State var test = ""
    @Binding var logInOK: Bool
    @State var tabBarVisivility: Visibility = .visible
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                Image("testImage")
                    .resizable()
                    .frame(height: UIScreen.screenHeight)
                Image("launchScreenLabel")
                
                VStack(spacing: 8) {
                    Spacer()
                    Button {
                        if UserApi.isKakaoTalkLoginAvailable() {
                            UserApi.shared.loginWithKakaoTalk(launchMethod: .CustomScheme) {(oauthToken, error) in
                                _ = oauthToken
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    singInStore.loadingInfoDidKakaoAuth()
                                    logInOK = true
                                }
                            }
                        } else {
                            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                                _ = oauthToken
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
                    .padding(.bottom, 58)
                    
                }
            }
            .ignoresSafeArea(.all)
            .navigationDestination(isPresented: $logInOK) {
                TabBarView(tabBarVisivility: $tabBarVisivility)
            }
            .onAppear(perform: {
                
            })
            .onDisappear {
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignInView(singInStore: SignInStore(), logInOK: .constant(false))
    }
}
