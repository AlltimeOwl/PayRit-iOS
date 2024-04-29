//
//  Data.swift
//  PayRit
//
//  Created by 임대진 on 4/27/24.
//

import Foundation

extension Data {
    func dataToString() -> String {
        return String(data: self, encoding: .utf8) ?? "empty"
    }
}
