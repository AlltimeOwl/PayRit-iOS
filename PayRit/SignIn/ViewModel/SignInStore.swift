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
    var userEmail = ""
    var userName = ""
    var userNickname = ""
    var userPhoneNumber = ""
    var aToken = ""
    var rToken = ""
    var signInState = false
//
//    let parameters: [String: Any] = [
//        "key1": "value1",
//        "key2": "value2"
//    ]
    func test() {
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
        
//        let url = "https://payrit.info/api/v1/oauth/KAKAO"
//        let parameters = TokenTestData(accessToken: aToken, refreshToken: rToken)
        
//        let parameters = [
//                            "accessToken" : aToken,
//                            "refreshToken": rToken,
//        ] as [String : Any]
//
//        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
//            .responseDecodable(of: TokenTestData.self) { response in
//                switch response.result {
//                case .success(let value):
//                    print("Response: \(value)")
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }
    }
    
    func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk(launchMethod: .CustomScheme) {(oauthToken, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.signInState = true
                    self.aToken = oauthToken?.accessToken ?? ""
                    self.rToken = oauthToken?.refreshToken ?? ""
                    UserApi.shared.me { kakaoUser, error in
                        if error != nil {
                            print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                            return
                        } else {
                                print(kakaoUser!)
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
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                _ = oauthToken
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.signInState = true
                    self.aToken = oauthToken?.accessToken ?? ""
                    self.rToken = oauthToken?.refreshToken ?? ""
                    UserApi.shared.me { kakaoUser, error in
                        if error != nil {
                            print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                            return
                        } else {
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
                self.userEmail = ""
                self.userName = ""
                self.userNickname = ""
                self.userPhoneNumber = ""
            }
        }
    }
//    func test1() {
//        let url = "https://payrit.info/api/v1/oauth/KAKAO"
//        let parameters:  = [
//            "accessToken": aToken,
//            "refreshToken": rToken
//        ] as [String: Any]
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
//
//            var request = URLRequest(url: URL(string: url)!)
//            request.httpMethod = "POST" // 요청에 사용할 HTTP 메서드 설정
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Content-Type 설정
//            request.setValue("application/json", forHTTPHeaderField: "accept") // Accept 설정
//            request.httpBody = jsonData // HTTP 바디 설정
//
//            let body =
//            AF.request(request)
//                .responseDecodable(of: TokenTestData.self) { response in
//                    switch response.result {
//                    case .success(let value):
//                        print("Response: \(value)")
//                    case .failure(let error):
//                        print("Error: \(error)")
//                    }
//                }
//        } catch {
//            print("Error encoding parameters: \(error)")
//        }
//    }

//    func test() {
//        let parameters = TokenTestData(accessToken: aToken, refreshToken: rToken)
//        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
//            .responseDecodable(of: TokenTestData.self) { response in
//                switch response.result {
//                case .success(let value):
//                    print("Response: \(value)")
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }
//    }
    
//    func checkKakaoTalkExe() {
        // 카카오톡 실행 가능 여부 확인
//        if UserApi.isKakaoTalkLoginAvailable() {
//            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                if let error = error {
//                    print(error)
//                } else {
//                    print("loginWithKakaoTalk() success.")
//                    if let oauthToken = oauthToken {
//                        self.aToken = oauthToken.accessToken
//                        self.rToken = oauthToken.refreshToken
//                        print("@-@-@")
//                        print(oauthToken)
//                    }
//                }
//            }
//        }
//
//    }
    
//    func loginKakaoAccount() {
//        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
//            if let error = error {
//                print(error)
//            } else {
//                print("loginWithKakaoAccount() success.")
//                if let oauthToken = oauthToken {
//                    self.aToken = oauthToken.accessToken
//                    self.rToken = oauthToken.refreshToken
//                    print("@-@-@")
//                    print(oauthToken)
//                }
//            }
//        }
//    }
}
