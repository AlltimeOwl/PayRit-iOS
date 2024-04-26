//
//  Promise.swift
//  PayRit
//
//  Created by 임대진 on 4/25/24.
//

import Foundation

public enum PromiseImage: String, Codable, CaseIterable {
    case COIN
    case HEART
    case FOOD
    case SHOPPING
    case COFFEE
    case PRESENT
    case BOOK
    case MONEY
}

struct Promise: Hashable, Codable {
    var amount: Int
    var promiseStartDate: Date
    var promiseEndDate: Date
    var contents: String
    var participantsName: String
    var participantsPhone: String
    var promiseImageType: PromiseImage
}

//struct participants: Hashable, Codable {
//    var participantsName: String
//    var participantsPhone: String
//}
//
//struct Promise: Hashable, Codable {
//    var amount: Int
//    var promiseStartDate: Date
//    var promiseEndDate: Date
//    var contents: String
//    var participants: [participants]
//    var promiseImageType: PromiseImage
//}
