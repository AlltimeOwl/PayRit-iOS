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
    @State var tabBarVisivility: Visibility = .visible
    @State var signInStore = SignInStore()
    var body: some View {
        if signInStore.signInState {
            TabBarView(tabBarVisivility: $tabBarVisivility, signInStore: $signInStore)
        } else {
            // onOpenURL()을 사용해 커스텀 URL 스킴 처리
            SignInView(signInStore: $signInStore).onOpenURL(perform: { url in
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
