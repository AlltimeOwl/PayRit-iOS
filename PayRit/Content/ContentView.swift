//
//  ContentView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

struct ContentView: View {
    let userDefault = UserDefaultsManager()
    @State private var isShowingReloginAlert: Bool = false
    @Environment(SignInStore.self) var signInStore
    @Environment(MyPageStore.self) var mypageStore
    
    var body: some View {
        if signInStore.isSignIn {
            CustomTabView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    Task {
                        await userDefault.getUserInfoAsync()
                        if let user = userDefault.user {
                            if user.signInCompany == "애플" {
                                signInStore.appleAuthCheck()
                                print("foreground 애플 auth check")
                            } else if user.signInCompany == "카카오톡" {
                                signInStore.kakaoAuthCheck()
                                print("foreground 카카오 auth check")
                            }
                        }
                    }
                }
                .onAppear {
                    Task {
                        await userDefault.getUserInfoAsync()
                        if let user = userDefault.user {
                            if user.signInCompany == "애플" {
                                mypageStore.currentUser = userDefault.getAppleUserInfo()
                            } else if user.signInCompany == "카카오톡" {
                                mypageStore.currentUser = userDefault.getUserInfo()
                            }
                        }
                        mypageStore.checkIMPAuth()
                    }
                }
        } else {
            SignInView().onOpenURL(perform: { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            })
        }
    }
}

#Preview {
    ContentView()
        .environment(SignInStore())
}
