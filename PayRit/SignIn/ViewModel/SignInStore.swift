//
//  SingInStore.swift
//  MoneyBridge
//
//  Created by 임대진 on 2/22/24.
//

import Foundation
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import CryptoKit
import AuthenticationServices

@Observable
class SignInStore {
    var userEmail = ""
    var userName = ""
    var userNickname = ""
    var userPhoneNumber = ""
    var aToken = ""
    var rToken = ""
    
    func checkKakaoTalkExe() {
        // 카카오톡 실행 가능 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    if let oauthToken = oauthToken {
                        self.aToken = oauthToken.accessToken
                        self.rToken = oauthToken.refreshToken
                        print("@-@-@")
                        print(oauthToken)
                    }
                }
            }
        }
    }
    
    func loginKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                if let oauthToken = oauthToken {
                    self.aToken = oauthToken.accessToken
                    self.rToken = oauthToken.refreshToken
                    print("@-@-@")
                    print(oauthToken)
                }
            }
        }
    }
    
    func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
        UserApi.shared.me { kakaoUser, error in
            if error != nil {
                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                return
            }
            
            if let email = kakaoUser?.kakaoAccount?.email {
                self.userEmail = email
            }
            if let name = kakaoUser?.kakaoAccount?.name {
                self.userName = name
            }
            if let nickname = kakaoUser?.kakaoAccount?.profile?.nickname {
                self.userNickname = nickname
            }
            if let phoneNumber = kakaoUser?.kakaoAccount?.phoneNumber {
                self.userPhoneNumber = phoneNumber
            }
        }
    }
    
    func kakaoSingOut() {
        UserApi.shared.logout { error in
            if let error = error {
                print("로그아웃에 실패했습니다: \(error)")
            } else {
                print("로그아웃이 성공적으로 수행되었습니다.")
            }
        }
    }
    
    func kakaoUnlink() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            } else {
                print("unlink() success.")
                self.userEmail = ""
                self.userName = ""
                self.userNickname = ""
                self.userPhoneNumber = ""
            }
        }
    }
}
