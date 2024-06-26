//
//  String +.swift
//  PayRit
//
//  Created by 임대진 on 3/21/24.
//

import Foundation

extension String {
    /// +82 10-0000-0000 -> 010-0000-0000
    func globalNumberToHyphen() -> String {
        if self.count == 16 {
            if self.prefix(3) == "+82" {
                let number = self.suffix(12)
                return "0" + String(number)
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    /// 010-0000-0000 -> +82 10-0000-0000
    func globalPhoneNumber() -> String {
        if self.count == 13 {
            return "+82 " + self.suffix(12)
        } else {
            return self
        }
    }
    
    func hyphen() -> String {
        let cleanNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXX-XXXX-XXXX"
        var result = ""
        var startIndex = cleanNumber.startIndex
        let endIndex = cleanNumber.endIndex
        
        for char in mask where startIndex < endIndex {
            if char == "X" {
                result.append(cleanNumber[startIndex])
                startIndex = cleanNumber.index(after: startIndex)
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    func notHyphen() -> String {
        return self.replacingOccurrences(of: "-", with: "")
    }
    
    func stringDateToKorea() -> String {
        let array = self.components(separatedBy: "-")
        if array.count == 3 {
            return "\(array[0]) 년 \(array[1]) 월 \(array[2]) 일"
        } else {
            return self
        }
    }
    
    func extractStringAfterMODIFY() -> String? {
        let text = self.components(separatedBy: "[MODIFY]")
        return text.last
    }
    
    func extractStringAfterSpecial() -> String? {
        let text = self.components(separatedBy: "[MODIFY]")
        return text.first
    }
    
    /// "2024-01-01 을 Date 타입으로 변환
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}
