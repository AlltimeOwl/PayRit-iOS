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

enum WhileSigIn {
    case waiting
    case doing
}

enum SiginInType: String, CodingKey, CaseIterable {
    case apple = "APPLE"
    case kakao = "KAKAO"
}

enum ServerAuthError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case parsingError
}

@Observable
class SignInStore {
    var isSignIn: Bool = UserDefaultsManager().getIsSignInState()
    var singinRevoke: Bool = false
    var whileSigIn: WhileSigIn = .waiting
    var appleAuthorizationCode = ""
    var appleIdentityToken = ""
    var firebasePushtoken = ""
    
    // MARK: - 애플
    func handleAppleSignInResult(_ result: Result<ASAuthorization, Error>) {
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
                
//                let IdentityToken = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8)
//                print("---------1-----------")
//                print("UserIdentifier : \(appleUserIdentifier)")
//                print("fullName : \(String(describing: fullName)))")
//                print("name : \(name)")
//                print("email : \(String(describing: email))")
//                print("IdentityToken : \(IdentityToken ?? "")")
//                print("---------1-----------")
                
                // AuthorizationCode 서버에 전송하는 값 !! 1번만 사용될 수 있으며 5분간 유효 !! appleIDCredential.user
                if  let authorizationCode = appleIDCredential.authorizationCode,
                    let identityToken = appleIDCredential.identityToken,
                    let authCodeString = String(data: authorizationCode, encoding: .utf8),
                    let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                    self.appleAuthorizationCode = authCodeString
                    self.appleIdentityToken = identifyTokenString
                    print("appleAuthorizationCode : \(authCodeString)")
                    print("appleIdentityToken : \(identifyTokenString)")
                    UserDefaultsManager().setAppleIdTokenString(appleIdTokenString: identifyTokenString)
                }
                if name.isEmpty && email.isEmpty {
                    UserDefaultsManager().setAppleSignIn(appleId: appleUserIdentifier, signInCompany: "애플")
                } else {
                    UserDefaultsManager().setAppleUserData(userData: User(name: name, email: email, phoneNumber: "", signInCompany: "애플", appleId: appleUserIdentifier))
                }
                appleAuthCheck()
                
            default:
                break
            }
        case .failure(let error):
            print(error.localizedDescription)
            print("error")
        }
    }
    
    func appleAuthCheck() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: UserDefaultsManager().getAppleUserId()) { (credentialState, _) in
            switch credentialState {
            case .authorized:
                print("애플 authorized")
                // The Apple ID credential is valid.
//                DispatchQueue.global().async {
                    // authorized된 상태이므로 바로 로그인 완료 화면으로 이동
                self.serverAuth(aToken: UserDefaultsManager().getAppleIdTokenString(), rToken: "rToken", company: .apple) { result in
                        switch result {
                        case .success(true):
                            print("서버 Sign in succeeded")
                            self.isSignIn = true
                            UserDefaultsManager().setIsSignInState(value: true)
                        case .success(false):
                            print("서버 Sign in failed")
                            self.isSignIn = false
                            UserDefaultsManager().setIsSignInState(value: false)
                        case .failure(let error):
                            print("서버 Error: \(error)")
                            self.isSignIn = false
                            UserDefaultsManager().setIsSignInState(value: false)
                        }
                    }
//                }
            case .revoked:
                // 인증이 취소됨
                print("애플 revoked")
                self.isSignIn = false
                UserDefaultsManager().setIsSignInState(value: false)
            case .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                // 인증을 알수없음 (최초 진입 등)
                print("애플 notFound")
                self.isSignIn = false
                UserDefaultsManager().setIsSignInState(value: false)
            default:
                break
            }
        }
    }
    
    func appleUnLink() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/oauth/revoke"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            let body = [
                "oauthCode": self.appleAuthorizationCode
            ] as [String: Any]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
            }
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
                        print("애플 탈퇴 완료")
                    } else {
                        print("Unexpected status code: \(response.statusCode)")
                    }
                } else {
                    print("Unexpected error: No data or response")
                }
            }
            task.resume()
        }
    }

    // MARK: - 카카오
    /// 카카오 로그인 시도
    func kakaoSignIn() {
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
                    UserDefaultsManager().setKakaoToken(kakaoToken: aToken)
                    self.serverAuth(aToken: aToken, rToken: rToken, company: .kakao) { result in
                        switch result {
                        case .success(true):
                            print("Sign in succeeded")
                            self.isSignIn = true
                            userDefault.setIsSignInState(value: true)
                        case .success(false):
                            print("Sign in failed")
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func kakaoAuthCheck() {
        let userDefault = UserDefaultsManager()
        // 토큰 존재 여부 확인하기
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        // 로그인 필요
                        self.isSignIn = false
                    } else {
                        // 기타 에러
                    }
                } else {
                    // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    let token = userDefault.getKakaoToken()
                    self.serverAuth(aToken: token, rToken: "rToken", company: .kakao) { result in
                        switch result {
                        case .success(true):
                            print("Sign in succeeded")
                            self.isSignIn = true
                            userDefault.setIsSignInState(value: true)
                        case .success(false):
                            print("Sign in failed")
                            self.isSignIn = false
                            UserDefaultsManager().setIsSignInState(value: false)
                        case .failure(let error):
                            print("Error: \(error)")
                            self.isSignIn = false
                            UserDefaultsManager().setIsSignInState(value: false)
                        }
                    }
                }
            }
        } else {
            // 로그인 필요
            self.isSignIn = false
        }
    }
    
    func kakaoSingOut() {
        UserApi.shared.logout { error in
            if let error = error {
                print("로그아웃에 실패했습니다: \(error)")
            } else {
                print("로그아웃이 성공적으로 수행되었습니다.")
                self.isSignIn = false
            }
        }
    }
    
    func kakaoUnLink() {
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
                
                let session = URLSession.shared
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("application/json", forHTTPHeaderField: "accept")
                request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
                
                let task = session.dataTask(with: request) { (_, response, error) in
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
//    func getToken() -> S
    // MARK: - 공용
    /// 서버에 JWT 보내고 Bearer를 userDefault에 저장
    func serverAuth(aToken: String, rToken: String, company: SiginInType, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.whileSigIn = .doing
        let userDefault = UserDefaultsManager()
        Task {
            await userDefault.loadFCMtoken()
            let firebaseToken = userDefault.firebaseToken ?? ""
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "www.payrit.info"
            urlComponents.path = "/api/v1/oauth/\(company.rawValue)"
            
            guard let url = urlComponents.url else {
                completion(.failure(ServerAuthError.invalidURL))
                return
            }
            print("--------firebaseTokenfirebaseToken---------")
            print(firebaseToken)
            print("--------firebaseTokenfirebaseToken---------")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "accept")
            
            let body = [
                "accessToken": aToken,
                "refreshToken": rToken,
                "firebaseToken": firebaseToken
            ] as [String: Any]
            print("--------bodybodybody---------")
            print(body)
            print("--------bodybodybody---------")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
                completion(.failure(error))
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    completion(.failure(ServerAuthError.invalidResponse))
                    return
                }
                
                print("Response status code: \(httpResponse.statusCode)")
                
                if (200..<300).contains(httpResponse.statusCode) {
                    guard let responseData = data else {
                        print("Invalid data")
                        completion(.failure(ServerAuthError.invalidData))
                        return
                    }
                    
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                            print("Parsing error")
                            completion(.failure(ServerAuthError.parsingError))
                            return
                        }
                        
                        print("JSON Response: \(json)")
                        
                        guard let accessToken = json["accessToken"] as? String, let refreshToken = json["refreshToken"] as? String else {
                            print("Access token or refresh token not found")
                            completion(.failure(ServerAuthError.parsingError))
                            return
                        }
                        
                        userDefault.setBearerToken(accessToken, refreshToken)
                        print("-----토큰 로드 성공-----")
                        print("aToken : \(accessToken)")
                        print("rToken : \(refreshToken)")
                        print("-----토큰 로드 성공-----")
                        
                        completion(.success(true))
                    } catch {
                        print("Error parsing JSON response: \(error)")
                        completion(.failure(error))
                    }
                    self.whileSigIn = .waiting
                } else {
                    print("Unexpected status code: \(httpResponse.statusCode)")
                    completion(.failure(ServerAuthError.invalidResponse))
                    self.whileSigIn = .waiting
                }
            }
            task.resume() // 작업 시작
        }
    }
}
