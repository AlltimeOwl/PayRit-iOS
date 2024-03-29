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
    @Environment(SignInStore.self) var signInStore
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                Image("firstImage")
                    .resizable()
                    .frame(height: UIScreen.screenHeight)
                Image("payRitText")
                
                if signInStore.whileSigIn == .waiting {
                    VStack(spacing: 8) {
                        Spacer()
                        Button {
                            signInStore.kakaoSignIn()
                        } label: {
                            HStack(spacing: 6) {
                                Spacer()
                                Image("kakaoSignInLogo")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                Text("카카오로 계속하기")
                                    .foregroundStyle(Color(hex: "000000").opacity(0.85))
                                    .font(.system(size: 18))
                                Spacer()
                            }
                        }
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "FEE500"))
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                        
                        SignInWithAppleButton(
                            .continue
                            ,
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                            },
                            onCompletion: signInStore.handleAppleSignInResult(_:)
                        )
                        .signInWithAppleButtonStyle(.black)
                        .cornerRadius(5)
                        .frame(height: 48)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 58)
                    }
                }
                
                if signInStore.whileSigIn == .doing {
                    ProgressView()
                }
            }
            .ignoresSafeArea(.all)
            .onAppear {
                
            }
            .onDisappear {
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignInView()
            .environment(SignInStore())
    }
}
