//
//  TabView.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI

struct CustomTabView: View {
    let iconSize: CGFloat = 24.0
    @Environment(TabBarStore.self) var tabStore
    
    var body: some View {
        
        ZStack {
            Color.brown.ignoresSafeArea()
            switch tabStore.selectedTab {
            case .home:
                HomeView()
            case .write:
                WritingView()
                    .tint(Color.payritMint)
            case .mypage:
                NavigationStack {
                    MyPageView()
                }
            }
            if !tabStore.tabBarHide {
                VStack {
                    Spacer()
                        ZStack {
                            HStack {
                                Spacer()
                                Button {
                                    tabStore.selectedTab = .home
                                } label: {
                                    VStack {
                                        Image("homeIcon")
                                            .resizable()
                                            .frame(width: iconSize, height: iconSize)
                                        Text("홈")
                                            .foregroundStyle(.black)
                                    }
                                    .opacity(tabStore.selectedTab == .home ? 1 : 0.3)
                                }
                                .frame(width: 60)
                                Spacer()
                                Button {
                                    tabStore.selectedTab = .write
                                } label: {
                                    VStack {
                                        Image("writeIcon")
                                            .resizable()
                                            .frame(width: iconSize, height: iconSize)
                                        Text("작성하기")
                                            .foregroundStyle(.black)
                                    }
                                    .opacity(tabStore.selectedTab == .write ? 1 : 0.4)
                                }
                                .frame(width: 60)
                                Spacer()
                                Button {
                                    tabStore.selectedTab = .mypage
                                } label: {
                                    VStack {
                                        Image("mypageIcon")
                                            .resizable()
                                            .frame(width: iconSize, height: iconSize)
                                        Text("마이페이지")
                                            .foregroundStyle(.black)
                                    }
                                    .opacity(tabStore.selectedTab == .mypage ? 1 : 0.4)
                                }
                                .frame(width: 60)
                                Spacer()
                            }
                            .buttonStyle(.plain)
                            .padding(.top, 10)
                            .padding(.bottom, 35)
                            .overlay {
                                                        if tabStore.tabBarOpacity {
                                UnevenRoundedRectangle(topLeadingRadius: 45, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 45, style: .circular)
                                    .fill(.black.opacity(0.5))
                                                        }
                            }
                        }
                        .tint(.payritMint)
                        .font(Font.caption03)
                        .frame(maxWidth: .infinity)
                        .background(
                            UnevenRoundedRectangle(topLeadingRadius: 45, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 45, style: .circular)
                                .fill(.white)
                                .ignoresSafeArea()
                        )
                        .shadow(color: .gray.opacity(0.2), radius: 8)
                }
                .ignoresSafeArea()
            }
        }
        .onAppear {
            tabStore.tabBarHide = false
        }
    }
    
}

#Preview {
    CustomTabView()
        .environment(HomeStore())
        .environment(SignInStore())
        .environment(TabBarStore())
}
