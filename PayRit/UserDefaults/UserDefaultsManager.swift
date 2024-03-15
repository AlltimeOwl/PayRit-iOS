//
//  UserDefaultsManager.swift
//  PayRit
//
//  Created by 임대진 on 3/15/24.
//

import Foundation

@Observable
final class UserDefaultsManager {
    enum Key: String, CaseIterable {
        case isSignIn
        case userAppleId, userName, userEmail, userPhoneNumber, signInCompany
    }
    
    // 카카오 정보저장
    func setKakaoUserData(userData: User) {
        UserDefaults.standard.setValue(userData.name, forKey: Key.userName.rawValue)
        UserDefaults.standard.setValue(userData.email, forKey: Key.userEmail.rawValue)
        UserDefaults.standard.setValue(userData.phoneNumber, forKey: Key.userPhoneNumber.rawValue)
        UserDefaults.standard.setValue(userData.signInCompany, forKey: Key.signInCompany.rawValue)
    }
    
    // 애플 정보저장
    func setAppleUserData(userData: User) {
        UserDefaults.standard.setValue(userData.appleId, forKey: Key.userAppleId.rawValue)
        UserDefaults.standard.setValue(userData.name, forKey: Key.userName.rawValue)
        UserDefaults.standard.setValue(userData.email, forKey: Key.userEmail.rawValue)
        UserDefaults.standard.setValue(userData.signInCompany, forKey: Key.signInCompany.rawValue)
    }
    
    // 자동로그인 값 저장
    func setIsSignInState(value: Bool) {
        UserDefaults.standard.setValue(value, forKey: Key.isSignIn.rawValue)
    }
    
    // 유저 정보 반환
    func getUserInfo() -> User {
        let name = UserDefaults.standard.string(forKey: Key.userName.rawValue) ?? ""
        let email = UserDefaults.standard.string(forKey: Key.userEmail.rawValue) ?? ""
        let phoneNumber = UserDefaults.standard.string(forKey: Key.userPhoneNumber.rawValue) ?? ""
        let company = UserDefaults.standard.string(forKey: Key.signInCompany.rawValue) ?? ""
        let appleId = UserDefaults.standard.string(forKey: Key.isSignIn.rawValue)
        return User(name: name, email: email, phoneNumber: phoneNumber, signInCompany: company, appleId: appleId)
    }
    
    // 저장된 애플 유저 고유 아이디값 반환
    func getAppleUserId() -> String {
        let appleId = UserDefaults.standard.string(forKey: Key.userAppleId.rawValue) ?? "notFound"
        return appleId
    }
    
    // 자동로그인 값 반환
    func getIsSignInState() -> Bool {
        let check = UserDefaults.standard.bool(forKey: Key.isSignIn.rawValue)
        return check
    }
    
    func removeAll() {
        Key.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}
