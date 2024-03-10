//
//  Memo.swift
//  PayRit
//
//  Created by 임대진 on 3/10/24.
//

import Foundation

struct Memo: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let text: String
    let day: Date = Date()
}
