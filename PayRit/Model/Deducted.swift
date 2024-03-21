//
//  Deducted.swift
//  PayRit
//
//  Created by 임대진 on 3/13/24.
//

import Foundation

struct Deducted: Hashable, Codable {
    let id: Int
    var repaymentDate: String
    var repaymentAmount: Int
}
