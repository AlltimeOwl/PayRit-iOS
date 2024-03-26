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
    let userDefault = UserDefaultsManager().getUserInfo()
    @State private var isShowingReloginAlert: Bool = false
    @Environment(SignInStore.self) var signInStore
    
    var body: some View {
        if signInStore.isSignIn {
            CustomTabView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    if userDefault.signInCompany == "애플" {
                        signInStore.appleAuthCheck()
                        print("애플 auth check")
                    } else if userDefault.signInCompany == "카카오톡" {
                        signInStore.kakaoAuthCheck()
                        print("카카오 auth check")
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
