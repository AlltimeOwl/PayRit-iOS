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
    var isSignIn: Bool = UserDefaultsManager().getIsSignInState()
    var appleAuthorizationCode = ""
    //
    //    let parameters: [String: Any] = [
    //        "key1": "value1",
    //        "key2": "value2"
    //    ]
    
    func appleSignIn() {
        
    }
    
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
    
//    func test2() {
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "appleid.apple.com"
//        urlComponents.path = "/auth/token"
//        
//        if let url = urlComponents.url {
//            print("URL: \(url)")
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST" // 요청에 사용할 HTTP 메서드 설정
//            // HTTP 헤더 설정
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            
//            // HTTP 바디 설정
//            let body = [
//                "client_id": "com.daejinlim.PayRit",
////                "client_se": aToken,
////                "code": aToken,
//                "grant_type": appleAuthorizationCode
//            ] as [String: Any]
//            
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
//            } catch {
//                print("Error creating JSON data")
//            }
//            // URLSession을 사용하여 요청 수행
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("Error: \(error)")
//                } else if let data = data, let response = response as? HTTPURLResponse {
//                    print("Response status code: \(response.statusCode)")
//                    if response.statusCode == 200 {
//                        // Handle successful response
//                        do {
//                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                                print("JSON Response: \(json)")
//                                //                                print(data)
//                            }
//                        } catch {
//                            print("Error parsing JSON response")
//                        }
//                    } else {
//                        // Handle other status codes
//                        print("Unexpected status code: \(response.statusCode)")
//                    }
//                } else {
//                    // Handle unexpected cases
//                    print("Unexpected error: No data or response")
//                }
//            }
//            task.resume() // 작업 시작
//        }
//    }
    
    /// 카카오 로그인 시도
    func kakaoSignIn() {
        let userDefault = UserDefaultsManager()
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk(launchMethod: .CustomScheme) {(oauthToken, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.getKakaoInfo(oauthToken: oauthToken)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.getKakaoInfo(oauthToken: oauthToken)
                }
            }
        }
    }
    
    /// 카카오 유저 정보, 토큰 가져오기
    func getKakaoInfo(oauthToken: OAuthToken?) {
        let userDefault = UserDefaultsManager()
        userDefault.setIsSignInState(value: true)
        print("-----카카오에서 받은 토큰-----")
        print(" accessToken : \(oauthToken?.accessToken ?? "")")
        print(" refreshToken : \(oauthToken?.refreshToken ?? "")")
        print("-----카카오에서 받은 토큰-----")
        UserApi.shared.me { kakaoUser, error in
            if error != nil {
                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                return
            } else {
                if let email = kakaoUser?.kakaoAccount?.email, let name = kakaoUser?.kakaoAccount?.name, let phoneNumber = kakaoUser?.kakaoAccount?.phoneNumber {
                    userDefault.setKakaoUserData(userData: User(name: name, email: email, phoneNumber: phoneNumber, signInCompany: "카카오톡"))
                }
                if let aToken = oauthToken?.accessToken, let rToken = oauthToken?.refreshToken {
                    self.serverAuth(aToken: aToken, rToken: rToken)
                    self.isSignIn = true
                    userDefault.setIsSignInState(value: true)
                }
            }
        }
    }
    
    /// 서버에 카카오 JWT 보내고 Bearer를 userDefault에 저장
    func serverAuth(aToken: String, rToken: String) {
        let userDefault = UserDefaultsManager()
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
                                if let accessToken = json["accessToken"] as? String, let refreshToken = json["refreshToken"] as? String {
                                    // accessToken을 저장합니다. 이 예제에서는 UserDefaults를 사용하여 저장합니다.
                                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                                    userDefault.setBearerToken(accessToken, refreshToken)
                                    print("-----토큰 저장 완료-----")
                                    print("aToken : \(accessToken)")
                                    print("rToken : \(refreshToken)")
                                    print("-----토큰 저장 완료-----")
                                }
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
    
    func kakaoSingOut() {
        UserApi.shared.logout { error in
            if let error = error {
                print("로그아웃에 실패했습니다: \(error)")
            } else {
                print("로그아웃이 성공적으로 수행되었습니다.")
                self.isSignIn = false
                UserDefaultsManager().removeAll()
            }
        }
    }
    
    func kakaoUnlink() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            } else {
                print("unlink() success.")
                self.isSignIn = false
                UserDefaultsManager().removeAll()
                
                    // 요청할 URL 생성
                    let urlString = "https://payrit.info/api/v1/oauth/leave"
                    guard let url = URL(string: urlString) else {
                        print("Invalid URL")
                        return
                    }
                    
                    // URLSession 객체 생성
                    let session = URLSession.shared
                    
                    // URLRequest 생성
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue("application/json", forHTTPHeaderField: "accept")
                    request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
                    
                    // URLSessionDataTask를 사용하여 GET 요청 생성
                    let task = session.dataTask(with: request) { (data, response, error) in
                        // 요청 완료 후 실행될 클로저
                        if let error = error {
                            print("Error: \(error)")
                            return
                        }
                        guard let httpResponse = response as? HTTPURLResponse else {
                            print("Invalid response")
                            return
                        }
                        
                        if (200..<300).contains(httpResponse.statusCode) {
                            print("탈퇴 완료")
                        } else {
                            print("HTTP status code: \(httpResponse.statusCode)")
                        }
                    }
                    task.resume()
            }
        }
    }
}
