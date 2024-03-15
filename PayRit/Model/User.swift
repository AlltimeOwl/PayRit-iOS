//
//  User.swift
//  PayRit
//
//  Created by 임대진 on 3/8/24.
//

import Foundation

struct User: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let email: String
    let phoneNumber: String
    let signInCompany: String
    var appleId: String?
}
