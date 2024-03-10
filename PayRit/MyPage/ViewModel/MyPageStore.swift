//
//  MyPageStore.swift
//  PayRit
//
//  Created by 임대진 on 3/8/24.
//

import Foundation

enum Reason: String, CodingKey, CaseIterable {
    case notUse = "최근 작성일 순"
    case expiration = "기간 만료일 순"
}

@Observable
final class MyPageStore {
    
}
