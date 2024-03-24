//
//  NotificationViewModel.swift
//  PayRit
//
//  Created by 임대진 on 3/24/24.
//

import Foundation

@Observable
final class NotificationStore {
    let userDefault = UserDefaultsManager()
    
    func notiClicked(noti: PayritNoti) {
        var notis = userDefault.loadNotifications()
        var clickedNoti = noti
        notis.removeAll(where: { $0.title == clickedNoti.title && $0.body == clickedNoti.body })
        clickedNoti.clicked = true
        notis.append(clickedNoti)
        userDefault.saveNotifications(notis)
    }
    
    func notiDelete(noti: PayritNoti) {
        var notis = userDefault.loadNotifications()
        notis.removeAll(where: { $0.title == noti.title && $0.body == noti.body })
        userDefault.saveNotifications(notis)
    }
}
