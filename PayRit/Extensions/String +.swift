//
//  String +.swift
//  PayRit
//
//  Created by 임대진 on 3/21/24.
//

import Foundation

extension String {
    // +82 10-5000-0000
    func onlyPhoneNumber() -> String {
        if self.prefix(3) == "+82" {
            let number = self.suffix(12)
            return "0" + String(number)
        } else {
            return self
        }
    }
    
    func globalPhoneNumber() -> String {
//        if self.count == 11 {
//            let firstPart = self.prefix(3)
//            let secondPart = self[self.index(self.startIndex, offsetBy: 3)..<self.index(self.startIndex, offsetBy: 7)]
//            let thirdPart = self.suffix(4)
//            return "\(firstPart)-\(secondPart)-\(thirdPart)"
//        } else {
//            return self
//        }
        var newNumber = self.suffix(12)
        return "+82 " + newNumber
    }
    
    func phoneNumberPlusSlider() -> String {
        if self.count == 3 {
            return self + "-"
        } else if self.count == 8 {
            return self + "-"
        }
        return self
    }
}
