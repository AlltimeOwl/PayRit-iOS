//
//  Date +.swift
//  PayRit
//
//  Created by 임대진 on 3/13/24.
//

import Foundation

extension Date {
    /// "yyyy-MM-dd"
    public func hyphenFomatter() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self as Date)
    }
    /// "yyyy.MM.dd"
    public func dotFomatter() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self as Date)
    }
    
    /// "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    public func dateToFullString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.string(from: self as Date)
    }
}
