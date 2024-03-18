//
//  Memo.swift
//  PayRit
//
//  Created by 임대진 on 3/10/24.
//

import Foundation

struct Memo: Identifiable, Hashable, Codable {
    let id: String = UUID().uuidString
    var today: String = ""
    var text: String = ""
}
