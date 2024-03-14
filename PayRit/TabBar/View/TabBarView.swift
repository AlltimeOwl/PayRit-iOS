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
    @Binding var signInStore: SignInStore
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(signInStore: $signInStore)
            .tabItem {
                Image(systemName: "house")
                    .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                Text("홈")
            }
            .tag(0)
            
            WritingView(tabBarVisivility: $tabBarVisivility)
            .tabItem {
                Image(systemName: "plus.circle")
                    .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                Text("작성하기")
            }
            .tag(1)
            
            NavigationStack {
                MyPageView(tabBarVisivility: $tabBarVisivility, signInStore: $signInStore)
            }
            .tabItem {
                Image(systemName: "person")
                    .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                Text("마이페이지")
            }
            .tag(2)
        }
        .tint(.payritMint)
    }
}

#Preview {
    TabBarView(tabBarVisivility: .constant(.visible), signInStore: .constant(SignInStore()))
}
