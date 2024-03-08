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
    let signInStore = SignInStore()
    @State var tabBarVisivility: Visibility = .visible
    @State var signInState = false
    var body: some View {
        if signInState {
            TabBarView(tabBarVisivility: $tabBarVisivility, signInState: $signInState)
        } else {
            // onOpenURL()을 사용해 커스텀 URL 스킴 처리
            SignInView(singInStore: signInStore, logInOK: $signInState).onOpenURL(perform: { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            })
            .onAppear {
                
            }
        }
    }
}

#Preview {
    ContentView()
}
