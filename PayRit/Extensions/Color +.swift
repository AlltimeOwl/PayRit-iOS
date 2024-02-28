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
//    rgba(35, 224, 190, 1)
    static let mainColor = Color(hex: "#23E0BE")
    static let buttonCleanColor = Color(hex: "#FAFAFA")
}
