//
//  TabBarStore.swift
//  PayRit
//
//  Created by 임대진 on 3/17/24.
//

import Foundation

enum SelectedTab {
    case home
    case write
    case mypage
}

@Observable
final class TabBarStore {
    var selectedTab: SelectedTab = .home
    var tabBarHide: Bool = false
    var tabBarOpacity: Bool = false
}
