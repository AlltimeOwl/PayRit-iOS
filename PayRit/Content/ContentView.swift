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
    @Environment(SignInStore.self) var signInStore
    
    var body: some View {
        if signInStore.isSignIn {
            CustomTabView()
        } else {
            // onOpenURL()을 사용해 커스텀 URL 스킴 처리
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
