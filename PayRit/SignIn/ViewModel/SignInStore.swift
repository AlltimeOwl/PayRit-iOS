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
import Alamofire

struct TokenTestData: Codable {
    let accessToken: String
    let refreshToken: String
}

@Observable
class SignInStore {
    var currenUser: User = UserDefaultsManager().getUserInfo()
    var aToken = ""
    var rToken = ""
    var appleAuthorizationCode = ""
    var isSignIn: Bool = UserDefaultsManager().getIsSignInState()
    //
    //    let parameters: [String: Any] = [
    //        "key1": "value1",
    //        "key2": "value2"
    //    ]
    
    func appleAuthCheck() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: UserDefaultsManager().getAppleUserId()) { (credentialState, _) in
            switch credentialState {
            case .authorized:
                print("authorized")
                // The Apple ID credential is valid.
                DispatchQueue.main.async {
                    // authorized된 상태이므로 바로 로그인 완료 화면으로 이동
                    self.isSignIn = true
                    UserDefaultsManager().setIsSignInState(value: true)
                }
            case .revoked:
                // 인증이 취소됨
                print("revoked")
                self.isSignIn = false
                UserDefaultsManager().setIsSignInState(value: false)
            case .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                // 인증을 알수없음 (최초 진입 등)
                print("notFound")
                self.isSignIn = false
                UserDefaultsManager().setIsSignInState(value: false)
            default:
                break
            }
        }
    }
    
    func test2() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "appleid.apple.com"
        urlComponents.path = "/auth/token"
        
        if let url = urlComponents.url {
            print("URL: \(url)")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST" // 요청에 사용할 HTTP 메서드 설정
            // HTTP 헤더 설정
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            // HTTP 바디 설정
            let body = [
                "client_id": "com.daejinlim.PayRit",
                "client_se": aToken,
                "code": aToken,
                "grant_type": appleAuthorizationCode
            ] as [String: Any]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
            }
            // URLSession을 사용하여 요청 수행
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data, let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if response.statusCode == 200 {
                        // Handle successful response
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                print("JSON Response: \(json)")
                                //                                print(data)
                            }
                        } catch {
                            print("Error parsing JSON response")
                        }
                    } else {
                        // Handle other status codes
                        print("Unexpected status code: \(response.statusCode)")
                    }
                } else {
                    // Handle unexpected cases
                    print("Unexpected error: No data or response")
                }
            }
            task.resume() // 작업 시작
        }
    }
    
    func serverTest() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.payrit.info"
        urlComponents.path = "/api/v1/oauth/KAKAO"
        
        // URL 구성 요소를 사용하여 URL 생성
        if let url = urlComponents.url {
            print("URL: \(url)")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST" // 요청에 사용할 HTTP 메서드 설정
            // HTTP 헤더 설정
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "accept")
            
            // HTTP 바디 설정
            let body = [
                "accessToken": aToken,
                "refreshToken": rToken
            ] as [String: Any]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
            }
            // URLSession을 사용하여 요청 수행
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data, let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if response.statusCode == 200 {
                        // Handle successful response
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                print("JSON Response: \(json)")
                                //                                print(data)
                            }
                        } catch {
                            print("Error parsing JSON response")
                        }
                    } else {
                        // Handle other status codes
                        print("Unexpected status code: \(response.statusCode)")
                    }
                } else {
                    // Handle unexpected cases
                    print("Unexpected error: No data or response")
                }
            }
            task.resume() // 작업 시작
        }
    }
    
    func kakaoSignIn() {  // 사용자 정보 불러오기
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk(launchMethod: .CustomScheme) {(oauthToken, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    UserDefaultsManager().setIsSignInState(value: true)
                    self.aToken = oauthToken?.accessToken ?? ""
                    self.rToken = oauthToken?.refreshToken ?? ""
                    UserApi.shared.me { kakaoUser, error in
                        if error != nil {
                            print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                            return
                        } else {
                            print(kakaoUser!)
                            if let email = kakaoUser?.kakaoAccount?.email {
                                self.currenUser.email = email
                            }
                            if let name = kakaoUser?.kakaoAccount?.name {
                                self.currenUser.name = name
                            }
                            if let phoneNumber = kakaoUser?.kakaoAccount?.phoneNumber {
                                self.currenUser.phoneNumber = phoneNumber
                            }
                            UserDefaultsManager().setKakaoUserData(userData: User(name: self.currenUser.name, email: self.currenUser.email, phoneNumber: self.currenUser.phoneNumber, signInCompany: "카카오톡"))
                            self.isSignIn = true
                            UserDefaultsManager().setIsSignInState(value: true)
                        }
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                _ = oauthToken
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    UserDefaultsManager().setIsSignInState(value: true)
                    self.aToken = oauthToken?.accessToken ?? ""
                    self.rToken = oauthToken?.refreshToken ?? ""
                    UserApi.shared.me { kakaoUser, error in
                        if error != nil {
                            print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                            return
                        } else {
                            if let email = kakaoUser?.kakaoAccount?.email {
                                self.currenUser.email = email
                            }
                            if let name = kakaoUser?.kakaoAccount?.name {
                                self.currenUser.name = name
                            }
                            if let phoneNumber = kakaoUser?.kakaoAccount?.phoneNumber {
                                self.currenUser.phoneNumber = phoneNumber
                            }
                            UserDefaultsManager().setKakaoUserData(userData: User(name: self.currenUser.name, email: self.currenUser.email, phoneNumber: self.currenUser.phoneNumber, signInCompany: "카카오톡"))
                            self.isSignIn = true
                            UserDefaultsManager().setIsSignInState(value: true)
                        }
                    }
                }
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
                self.currenUser.email = ""
                self.currenUser.name = ""
                self.currenUser.phoneNumber = ""
            }
        }
    }
}
