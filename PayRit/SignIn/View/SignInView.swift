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
    @Environment(SignInStore.self) var signInStore
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
                        signInStore.kakaoSignIn()
                    } label: {
                        Image("kakaoLoginImage")
                    }
                    
//                    Button {
//                        signInStore.signInState = true
//                    } label: {
//                        Image("appleLoginImage")
//                    }
                    AppleSigninButton()
                    .frame(width: UIScreen.screenWidth * 0.8, height: 48)
                    .padding(.bottom, 58)
                    
                    Button {
                    } label: {
                        Image("kakaoLoginImage")
                    }
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
        SignInView()
    }
}

struct AppleSigninButton: View {
    @Environment(SignInStore.self) var signInStore
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Apple Login Successful")
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        // 계정 정보 가져오기
                        let appleUserIdentifier = appleIDCredential.user
                        let fullName = appleIDCredential.fullName
                        let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                        let email = appleIDCredential.email ?? ""
                        
                        let IdentityToken = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8)
                        print("---------1-----------")
                        print("UserIdentifier : \(appleUserIdentifier)")
                        print("fullName : \(String(describing: fullName)))")
                        print("name : \(name)")
                        print("email : \(String(describing: email))")
                        print("IdentityToken : \(IdentityToken ?? "")")
                        print("---------1-----------")
                        
                        // AuthorizationCode 서버에 전송하는 값 !! 1번만 사용될 수 있으며 5분간 유효 !!
                        if let AuthorizationCode = String(data: appleIDCredential.authorizationCode ?? Data(), encoding: .utf8) {
                            signInStore.appleAuthorizationCode = AuthorizationCode
                            print("AuthorizationCode : \(signInStore.appleAuthorizationCode)")
                        }
                        
                        UserDefaultsManager().setAppleUserData(userData: User(name: name, email: email, phoneNumber: "", signInCompany: "애플", appleId: appleUserIdentifier))
                        signInStore.appleAuthCheck()
                        
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                }
            }
        )
        .cornerRadius(5)
    }
}
