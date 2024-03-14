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
    @State var test = ""
    @Binding var signInStore: SignInStore
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                Image("testImage")
                    .resizable()
                    .frame(height: UIScreen.screenHeight)
                Image("payRitText")
                
                VStack(spacing: 8) {
                    Spacer()
                    Button {
                        signInStore.loadingInfoDidKakaoAuth()
                    } label: {
                        Image("kakaoLoginImage")
                    }
                    
                    Button {
                        signInStore.signInState = true
                    } label: {
                        Image("appleLoginImage")
                    }
                    .frame(width: UIScreen.screenWidth * 0.9, height: 48)
                    .padding(.bottom, 58)
                    
                }
            }
            .ignoresSafeArea(.all)
//            .navigationDestination(isPresented: $logInOK) {
//                TabBarView(tabBarVisivility: $tabBarVisivility)
//            }
            .onAppear {
                
            }
            .onDisappear {
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignInView(signInStore: .constant(SignInStore()))
    }
}
