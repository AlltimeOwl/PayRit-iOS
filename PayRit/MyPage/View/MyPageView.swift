//
//  MyPageView.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import SwiftUI

struct MyPageView: View {
    @State var listItemHeight: CGFloat = 40
    @State var isShowingSignOut: Bool = false
    @State var notFoundUser: Bool = false
    @Environment(SignInStore.self) var signInStore
    @Environment(TabBarStore.self) var tabStore
    let mypageStore: MyPageStore = MyPageStore()
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 16) {
                    Circle()
                        .frame(height: 77)
                        .foregroundStyle(.blue)
                    VStack(alignment: .leading, spacing: 10) {
                        Text(mypageStore.currenUser.name)
                            .font(Font.title01)
                        Text(mypageStore.currenUser.email)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.gray05)
                    }
                    .frame(height: 77)
                    Spacer()
                }
                .padding(.horizontal, 16)
                List {
                    NavigationLink {
                        MyInfoView()
                            .customBackbutton()
                            .onAppear {
                                tabStore.tabBarHide = true
                            }
                    } label: {
                        Text("계정 정보")
                    }
                    .frame(height: listItemHeight)
                    NavigationLink {
                        PaymentHistoryView()
                            .customBackbutton()
                            .onAppear {
                                tabStore.tabBarHide = true
                            }
                    } label: {
                        Text("결제 내역")
                    }
                    .frame(height: listItemHeight)
                    NavigationLink {
                        AlarmSettingView()
                            .customBackbutton()
                            .onAppear {
                                tabStore.tabBarHide = true
                            }
                            .onDisappear {
                                tabStore.tabBarHide = false
                            }
                    } label: {
                        Text("알림 설정")
                    }
                    .frame(height: listItemHeight)
                    NavigationLink {
                        
                    } label: {
                        Text("공지사항")
                    }
                    .frame(height: listItemHeight)
                    NavigationLink {
                        
                    } label: {
                        Text("자주 묻는 질문")
                    }
                    .frame(height: listItemHeight)
                    NavigationLink {
                        
                    } label: {
                        Text("서비스 이용 약관")
                    }
                    .frame(height: listItemHeight)
                    Button {
                        isShowingSignOut.toggle()
                    } label: {
                        Text("로그아웃")
                    }
                    .frame(height: listItemHeight)
                    .listRowBackground(Color.payritBackground)
                }
                .listStyle(.plain)
                .background(Color.payritBackground)
                .font(Font.body02)
                .disabled(notFoundUser)
                .padding(.top, 30)
                .padding(.trailing, 16)
                Spacer()
            }
        }
        .onAppear {
            tabStore.tabBarHide = false
        }
        .toolbar {
            ToolbarItem {
                Text("")
            }
        }
        .primaryAlert(isPresented: $isShowingSignOut, title: "로그아웃", content: "로그아웃 하시겠습니까?", primaryButtonTitle: "아니오", cancleButtonTitle: "네", primaryAction: nil) {
            if mypageStore.currenUser.signInCompany == "카카오톡" {
                signInStore.kakaoSingOut()
            } else if mypageStore.currenUser.signInCompany == "애플" {
                
                signInStore.isSignIn = false
                UserDefaultsManager().removeAll()
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
            .environment(TabBarStore())
            .environment(SignInStore())
    }
}
