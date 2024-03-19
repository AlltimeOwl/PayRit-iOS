//
//  Date +.swift
//  PayRit
//
//  Created by 임대진 on 3/13/24.
//

import Foundation

extension Date {
    public func dateToString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
//            formatter.locale = Locale.current
//            formatter.timeZone = TimeZone.current
        return formatter.string(from: self as Date)
    }
}
