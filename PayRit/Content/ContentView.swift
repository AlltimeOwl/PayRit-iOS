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
    @State var logInOK = false
    var body: some View {
        if logInOK {
            TabBarView(tabBarVisivility: $tabBarVisivility)
        } else {
            SignInView(singInStore: signInStore, logInOK: $logInOK).onOpenURL(perform: { url in
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