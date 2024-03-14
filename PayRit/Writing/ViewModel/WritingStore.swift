//
//  WritingStore.swift
//  PayRit
//
//  Created by 임대진 on 3/13/24.
//

import Foundation
import SwiftUI

@Observable
final class WritingStore {
    
    func convertToKoreanNumber(_ number: Int) -> String {
        let numbers = ["영", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"]
        let units = ["", "십", "백", "천"]
        let largeUnits = ["", "만", "억", "조", "경", "해"]
        
        var result = ""
        var number = number
        var unitIndex = 0
        
        while number > 0 {
            let digit = number % 10
            let unit = units[unitIndex % 4]
            let largeUnit = largeUnits[unitIndex / 4]
            
            if digit != 0 {
                result = numbers[digit] + unit + result
            }
            
            number /= 10
            unitIndex += 1
            
            if unitIndex % 4 == 0 {
                result = largeUnit + result
            }
        }
        
        return result.isEmpty ? "영" : result
    }

}
