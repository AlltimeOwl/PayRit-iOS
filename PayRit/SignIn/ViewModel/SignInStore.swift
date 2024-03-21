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

struct TokenTestData: Codable {
    let accessToken: String
    let refreshToken: String
}

@Observable
class SignInStore {
    var isSignIn: Bool = UserDefaultsManager().getIsSignInState()
    var appleAuthorizationCode = ""
    var appleIdentityToken = ""
    
//    func getAppleRefreshToken(code: String, completionHandler: @escaping (AppleTokenResponse) -> Void) {
//        let url = "https://appleid.apple.com/auth/token"
//        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
//        let parameters: Parameters = [
//            "client_id": "앱번들id",
//            "client_secret": "1번의jwt토큰",
//            "code": code,
//            "grant_type": "authorization_code"
//        ]
//
//        AF.request(url,
//                   method: .post,
//                   parameters: parameters,
//                   headers: header)
//        .validate(statusCode: 200..<300)
//        .responseData { response in
//            switch response.result {
//            case .success:
//                guard let data = response.data else { return }
//                let responseData = JSON(data)
//                print(responseData)
//
//                guard let output = try? JSONDecoder().decode(AppleTokenResponse.self, from: data) else {
//                    print("Error: JSON Data Parsing failed")
//                    return
//                }
//
//                completionHandler(output)
//            case .failure:
//                print("애플 토큰 발급 실패 - \(response.error.debugDescription)")
//            }
//        }
//    }
//    func revokeAppleToken(clientSecret: String, token: String, completionHandler: @escaping () -> Void) {
//        let url = "https://appleid.apple.com/auth/revoke"
//        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
//        let parameters: Parameters = [
//            "client_id": "com.daejinlim.PayRit",
//            "client_secret": clientSecret,
//            "token": token
//        ]
//
//        AF.request(url,
//                   method: .post,
//                   parameters: parameters,
//                   headers: header)
//        .validate(statusCode: 200..<300)
//        .responseData { response in
//            guard let statusCode = response.response?.statusCode else { return }
//            if statusCode == 200 {
//                print("애플 토큰 삭제 성공!")
//                completionHandler()
//            }
//        }
//    }
    
    // MARK: - 애플
    func appleAuthCheck() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: UserDefaultsManager().getAppleUserId()) { (credentialState, _) in
            switch credentialState {
            case .authorized:
                print("애플 authorized")
                // The Apple ID credential is valid.
                DispatchQueue.main.async {
                    // authorized된 상태이므로 바로 로그인 완료 화면으로 이동
                    self.serverAuth(aToken: self.appleIdentityToken, rToken: "rToken", company: .apple) { result in
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
    
    func appleUnLink() {
        let urlString = "https://payrit.info/api/v1/oauth/revoke?oauthCode=\(appleAuthorizationCode)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(appleIdentityToken)", forHTTPHeaderField: "Authorization")
        
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

    // MARK: - 카카오
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
                
                // URLSession 객체 생성
                let session = URLSession.shared
                
                // URLRequest 생성
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("application/json", forHTTPHeaderField: "accept")
                request.setValue("Bearer \(UserDefaultsManager().getBearerToken().aToken)", forHTTPHeaderField: "Authorization")
                
                // URLSessionDataTask를 사용하여 GET 요청 생성
                let task = session.dataTask(with: request) { (_, response, error) in
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
    
    // MARK: - 공용
    /// 서버에 JWT 보내고 Bearer를 userDefault에 저장
    func serverAuth(aToken: String, rToken: String, company: SiginInType, completion: @escaping (Result<Bool, Error>) -> Void) {
        let userDefault = UserDefaultsManager()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.payrit.info"
        urlComponents.path = "/api/v1/oauth/\(company.rawValue)"
        
        // URL 구성 요소를 사용하여 URL 생성
        guard let url = urlComponents.url else {
            completion(.failure(ServerAuthError.invalidURL))
            return
        }
        
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
            completion(.failure(error))
            return
        }
        
        // URLSession을 사용하여 요청 수행
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
            
            if httpResponse.statusCode == 200 {
                // Handle successful response
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
                    
                    // accessToken을 저장합니다. 이 예제에서는 UserDefaults를 사용하여 저장합니다.
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
            } else {
                // Handle other status codes
                print("Unexpected status code: \(httpResponse.statusCode)")
                completion(.failure(ServerAuthError.invalidResponse))
            }
        }
        task.resume() // 작업 시작
    }
}
