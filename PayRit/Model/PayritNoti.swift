//
//  Notification.swift
//  PayRit
//
//  Created by 임대진 on 3/24/24.
//

import Foundation

struct PayritNoti: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var date: String = Date().dateToString()
    let title: String
    let body: String
    var clicked: Bool = false
    
    static let testNoti: [PayritNoti] = [PayritNoti(title: "페이릿 승인 요청", body: "박이릿님께서 페이릿 승인 요청을 보내셨습니다."),
                                           PayritNoti(title: "페이릿 승인 요청", body: "박이릿님께서 페이릿 승인 요청을 보내셨습니다."),
                                           PayritNoti(title: "페이릿 승인 요청", body: "박이릿님께서 페이릿 승인 요청을 보내셨습니다."),
                                           PayritNoti(title: "페이릿 승인 요청", body: "박이릿님께서 페이릿 승인 요청을 보내셨습니다.")]
}
