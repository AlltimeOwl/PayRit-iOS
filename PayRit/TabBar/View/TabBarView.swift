//
//  TabView.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    @Binding var tabBarVisivility: Visibility
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.white
        // 탭 바 모양
//        let appearance = UITabBarAppearance()
//        appearance.configureWithDefaultBackground()
        
        // 스크롤될 때의 모양
//        let scrollEdgeAppearance = UITabBarAppearance()
//        scrollEdgeAppearance.configureWithDefaultBackground()
        
//        UITabBar.appearance().standardAppearance = appearance
//        UITabBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
//    }
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
                    .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                Text("홈")
            }
            .tag(0)
            
            NavigationStack {
                WritingView()
            }
            .tabItem {
                Image(systemName: "plus.circle")
                    .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                Text("작성하기")
            }
            .tag(1)
            
            NavigationStack {
                MyPageView(tabBarVisivility: $tabBarVisivility)
            }
            .tabItem {
                Image(systemName: "person")
                    .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                Text("마이페이지")
            }
            .tag(2)
            .onTapGesture {
                tabBarVisivility = .hidden
            }
        }
        .tint(.mainColor)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TabBarView(tabBarVisivility: .constant(.visible))
}
