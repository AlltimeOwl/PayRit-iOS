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

    // MARK: - Primary
    /// 카카오 로그인 버튼 색상
    static let kakaoLoginButton = Color(hex: "#F9E001")
    /// 민트 28D7D2
    static let payritMint = Color(hex: "28D7D2")
    /// 라이트 민트 CBF0EF
    static let payritLightMint = Color(hex: "CBF0EF")
    /// 마인드 그린 44DD88
    static let payritMindGreen = Color(hex: "44DD88")
    
    // MARK: - Secondary
    /// 핑크 FF7A90
    static let payritIntensivePink = Color(hex: "FF7A90")
    /// 라이트 핑크 FFD7DD
    static let payritIntensiveLightPink = Color(hex: "FFD7DD")
    
    /// 하늘색  FFCC55
    static let payritWithYellow = Color(hex: "FFCC55")
    /// System Error  레드 컬러  FE1111
    static let payritErrorRed = Color(hex: "FE1111")
    /// System Positive 청록 컬러  00DD22
    static let payritPositive = Color(hex: "00DD22")
    
    // MARK: - grayColor
    /// 181818
    static let gray00 = Color(hex: "181818")
    /// 212626
    static let gray01 = Color(hex: "212626")
    /// 2E3636
    static let gray02 = Color(hex: "2E3636")
    /// 3F4B4B
    static let gray03 = Color(hex: "3F4B4B")
    /// 5E6969
    static let gray04 = Color(hex: "5E6969")
    /// 7D8888
    static let gray05 = Color(hex: "7D8888")
    /// BCC7C7
    static let gray06 = Color(hex: "BCC7C7")
    /// D1DBDB
    static let gray07 = Color(hex: "D1DBDB")
    /// ECF0F0
    static let gray08 = Color(hex: "ECF0F0")
    /// F9F9F9
    static let gray09 = Color(hex: "F9F9F9")
    
}
