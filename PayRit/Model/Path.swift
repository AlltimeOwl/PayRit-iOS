//
//  Path.swift
//  PayRit
//
//  Created by 임대진 on 4/30/24.
//

import Foundation

public enum PathType {
    case payritDetail
    case accept
    case searching
    case noti
    case none
}

struct PayritPath: Hashable {
    let type: PathType
    let paperId: Int
    let step: CertificateStep
    let isWriter: Bool
}

struct PromisePath: Hashable {
    let detail: Promise
}
