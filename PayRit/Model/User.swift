//
//  User.swift
//  PayRit
//
//  Created by 임대진 on 3/8/24.
//

import Foundation

struct User: Identifiable {
    let id: String = UUID().uuidString
    var name: String
    var email: String
    var phoneNumber: String
    var signInCompany: String
    var appleId: String?
    var signature: Bool = false
}
