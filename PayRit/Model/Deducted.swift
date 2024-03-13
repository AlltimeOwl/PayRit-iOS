//
//  Deducted.swift
//  PayRit
//
//  Created by 임대진 on 3/13/24.
//

import Foundation

struct Deducted: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var date: String
    var money: Int
}
