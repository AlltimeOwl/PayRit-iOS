//
//  HomeViewModel.swift
//  PayRit
//
//  Created by 임대진 on 3/2/24.
//

import Foundation

enum SortingType: String, CodingKey, CaseIterable {
    case recent = "최근 작성일 순"
    case old = "작성 오래된 순"
    case expiration = "기간 만료일 순"
}

@Observable
final class HomeStore {
    var sortingType: SortingType = .recent
    var document: [Certificate] = Certificate.samepleDocument
    
    func sortingDocument() {
        document = Certificate.samepleDocument.sorted {
            switch sortingType {
            case .recent:
                return $0.writingDayCal < $1.writingDayCal
            case .old:
                return $0.writingDayCal > $1.writingDayCal
            case .expiration:
                return $0.dDay < $1.dDay
            }}
    }
}
