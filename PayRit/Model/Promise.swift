//
//  Promise.swift
//  PayRit
//
//  Created by 임대진 on 4/25/24.
//

import Foundation

public enum PromiseImage: String, Codable, CodingKey, CaseIterable {
    case COIN
    case HEART
    case FOOD
    case SHOPPING
    case COFFEE
    case PRESENT
    case BOOK
    case MONEY
}

struct Participants: Hashable, Codable {
    var participantsName: String
    var participantsPhone: String
}

struct Promise: Hashable, Codable {
    let promiseId: Int
    var amount: Int
    var promiseStartDate: Date
    var promiseEndDate: Date
    var writerName: String
    var contents: String
    var participants: [Participants]
    var promiseImageType: PromiseImage
    var isClicked: Bool = false
}
