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
import FirebaseAnalytics

enum WhileSignIn {
    case not
    case doing
}

enum SignInInType: String, CodingKey, CaseIterable {
    case apple = "APPLE"
    case kakao = "KAKAO"
}

enum ServerAuthError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case parsingError
    case serverClosed
}

enum LogOutMessage: String, CodingKey {
    case none
    case serverStop
    case authRevoke
}

@Observable
class SignInStore {
    var isSignIn: Bool = UserDefaultsManager().getIsSignInState()
    let signInCompany = UserDefaultsManager().getUserInfo().signInCompany
    var singinRevoke: Bool = false
    var serverIsClosed: LogOutMessage = .none
    var whileSignIn: WhileSignIn = .not
    var appleAuthorizationCode = ""
    var appleIdentityToken = ""
    var firebasePhtoken = ""
    var kakaoAuthCount = 0
    
    // MARK: - 애플
    func handleAppleSignInResult(_ result: Result<ASAuthorization, Error>) {
        Analytics.logEvent("apple_signIn_iOS", parameters: [:])
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
    
    func test() {
    }
    
    func appleAuthCheck() {
        print("asdasd")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: UserDefaultsManager().getAppleUserId()) { (credentialState, _) in
            switch credentialState {
            case .authorized:
                print("애플 authorized")
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
    
    func appleUnLink(completion: @escaping (Bool) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "payrit.info"
        urlComponents.path = "/api/v1/oauth/revoke"
        
        if let url = urlComponents.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                    if (200..<300).contains(response.statusCode) {
                        print("애플 탈퇴 완료")
                        UserDefaultsManager().removeAll(signInType: .apple)
                        completion(true)
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
        Analytics.logEvent("kakao_signIn_iOS", parameters: [:])
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
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        var newToken = ""
                        AuthApi.shared.refreshToken { token, _ in
                            newToken = token?.accessToken ?? ""
                            print("토큰 갱신 : newToken = \(newToken)")
                        }
                        
                        if self.kakaoAuthCount > 1 {
                            self.isSignIn = false
                            userDefault.setIsSignInState(value: false)
                            self.kakaoAuthCount = 0
                        } else {
                            self.kakaoAuthCheck()
                            self.kakaoAuthCount += 1
                        }
                    } else {
                        // 기타 에러
                        self.isSignIn = false
                        userDefault.setIsSignInState(value: false)
                        self.kakaoAuthCount = 0
                    }
                } else {
                    self.kakaoAuthCount = 0
                    guard let token = AUTH.tokenManager.getToken()?.accessToken else { return }
                    self.serverAuth(aToken: token, rToken: "rToken", company: .kakao) { result in
                        switch result {
                        case .success(true):
                            print("Sign in succeeded")
                            self.isSignIn = true
                            userDefault.setIsSignInState(value: true)
                        case .success(false):
                            print("Sign in failed")
                            self.isSignIn = false
                            userDefault.setIsSignInState(value: false)
                        case .failure(let error):
                            print("Error: \(error)")
                            self.isSignIn = false
                            userDefault.setIsSignInState(value: false)
                        }
                    }
                }
            }
        } else {
            // 로그인 필요
            self.isSignIn = false
            userDefault.setIsSignInState(value: false)
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
    
    func kakaoUnLink(completion: @escaping (Bool) -> Void) {
        let urlString = "https://payrit.info/api/v1/oauth/revoke"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                print("카카오 탈퇴 성공")
                UserApi.shared.unlink {(error) in
                    if let error = error {
                        print("unlink() error : \(error.localizedDescription)")
                    } else {
                        print("unlink() success.")
                        UserDefaultsManager().removeAll(signInType: .kakao)
                        completion(true)
                    }
                }
            } else {
                print("카카오 탈퇴 실패")
                if let data = data {
                    let responseData = String(data: data, encoding: .utf8)
                    print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                } else {
                    print("no data")
                }
            }
        }
        task.resume()
    }
    
    // MARK: - 공용
    /// 서버에 JWT 보내고 Bearer를 userDefault에 저장
    func serverAuth(aToken: String, rToken: String, company: SignInInType, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.whileSignIn = .doing
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
                "firebaseToken": firebaseToken,
                "authorizationCode": company == .apple ? appleAuthorizationCode : "null"
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
                    self.whileSignIn = .not
                    self.serverIsClosed = .none
                } else {
                    print("Unexpected status code: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 502 {
                        print("서버 점검중")
                        self.whileSignIn = .not
                        self.serverIsClosed = .serverStop
                        completion(.failure(ServerAuthError.serverClosed))
                    } else {
                        self.whileSignIn = .not
                        self.serverIsClosed = .authRevoke
                        completion(.failure(ServerAuthError.invalidResponse))
                    }
                    
                    if let data = data {
                        let responseData = String(data: data, encoding: .utf8)
                        print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                    } else {
                        print("no data")
                    }
                }
            }
            task.resume() // 작업 시작
        }
    }
}
