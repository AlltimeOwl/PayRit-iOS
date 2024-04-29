//
//  Notification.swift
//  PayRit
//
//  Created by 임대진 on 3/24/24.
//

import Foundation

struct PayritNoti: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var date: String = Date().hyphenFomatter()
    let title: String
    let body: String
    var clicked: Bool = false
}
