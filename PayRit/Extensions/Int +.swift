//
//  Int +.swift
//  PayRit
//
//  Created by 임대진 on 3/24/24.
//

import Foundation

extension Int {
    func numberToKorean() -> String {
        let numberUnits = ["", "만", "억", "조"]
        let digitUnits = ["", "십", "백", "천"]
        let koreanNumbers = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"]
        
        if self == 0 {
            return "영"
        }
        
        var result = ""
        var num = self
        var unitIndex = 0
        
        while num > 0 {
            let part = num % 10000 // 만 단위로 분리
            var partResult = ""
            var partNum = part
            var digitIndex = 0
            
            while partNum > 0 {
                let digit = partNum % 10 // 각 자리수 분리
                if digit > 0 {
                    partResult = koreanNumbers[digit] + digitUnits[digitIndex] + partResult
                }
                partNum /= 10
                digitIndex += 1
            }
            
            if part > 0 {
                result = partResult + numberUnits[unitIndex] + result
            }
            num /= 10000
            unitIndex += 1
        }
        
        return result
    }
}
