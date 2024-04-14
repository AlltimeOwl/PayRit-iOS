//
//  Date +.swift
//  PayRit
//
//  Created by 임대진 on 3/13/24.
//

import Foundation

extension Date {
    /// "yyyy-MM-dd"
    public func dateToString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
//            formatter.locale = Locale.current
//            formatter.timeZone = TimeZone.current
        return formatter.string(from: self as Date)
    }
    
    /// "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    public func dateToString2() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.string(from: self as Date)
    }
}
