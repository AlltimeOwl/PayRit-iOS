//
//  Color +.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//
import Foundation
import SwiftUI

public extension Color {
    // MARK: #FFFFFF와 같이 16진수 hexString color를 쓸 수 있음.
    init(hex: String, opacity: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }

    // MARK: 정의된 Color와 겹치지 않는 닉네임 선정
    /// 카카오 로그인 버튼 색상
    static let kakaoLoginButton = Color(hex: "#F9E001")
    
    static let mainColor = Color(hex: "#23E0BE")
    
    /// 내용이 담긴 박스 회색 버튼 색상 5F5F5F
    static let boxGrayColor = Color(hex: "F5F5F5")
    /// 디데이 표시 캡슐 색상 5F5F5F
    static let dDayCapsulColor = Color(hex: "5F5F5F")
    
    /// 연한 민트 색상 E3FFF6
    static let semeMintColor = Color(hex: "E3FFF6")
    
    /// 민트 컬러 37D9BC
    static let mintColor = Color(hex: "37D9BC")
    
    static let whiteColor = Color(hex: "FFFFFF")
    
    /// 연한 그레이 FAFAFA
    static let semiGrayColor1 = Color(hex: "FAFAFA")
    
    /// 연한 그레이 666666
    static let semiGrayColor2 = Color(hex: "666666")
    
    /// 연한 그레이 767676
    static let semiGrayColor3 = Color(hex: "767676")
    
    /// 섹션 타이틀 컬러 949494
    static let sectionTitleColor = Color(hex: "949494")
    
    /// 캡슐 그레이 컬러 A5A5A5
    static let capsulGrayColor = Color(hex: "A5A5A5")
}
