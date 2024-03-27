//
//  MyPageView.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import SwiftUI

struct MyPageView: View {
    let mypageStore: MyPageStore = MyPageStore()
    @State var listItemHeight: CGFloat = 40
    @State var isShowingSignOut: Bool = false
    @State var isShowingSafariView: Bool = false
    @State var notFoundUser: Bool = false
    @Environment(HomeStore.self) var homeStore
    @Environment(SignInStore.self) var signInStore
    @Environment(TabBarStore.self) var tabStore
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 70))
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
                        Text("준비중 입니다.")
                            .customBackbutton()
                            .onAppear {
                                tabStore.tabBarHide = true
                            }
//                        PaymentHistoryView()
//                            .customBackbutton()
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
                        Text("준비중 입니다.")
                            .customBackbutton()
                            .onAppear {
                                tabStore.tabBarHide = true
                            }
                    } label: {
                        Text("공지사항")
                    }
                    .frame(height: listItemHeight)
                    NavigationLink {
                        Text("준비중 입니다.")
                            .customBackbutton()
                            .onAppear {
                                tabStore.tabBarHide = true
                            }
                    } label: {
                        Text("자주 묻는 질문")
                    }
                    .frame(height: listItemHeight)
                    Button {
                        isShowingSafariView.toggle()
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
            .onAppear {
                tabStore.tabBarHide = false
            }
            .toolbar {
                ToolbarItem {
                    Text("")
                }
            }
            .fullScreenCover(isPresented: $isShowingSafariView) {
                if let url = URL(string: "https://picayune-rhinoceros-77c.notion.site/57721e2e46bf46b7a15cc05afec24fc3") {
                    SafariView(url: url)
                }
            }
            .primaryAlert(isPresented: $isShowingSignOut, title: "로그아웃", content: "로그아웃 하시겠습니까?", primaryButtonTitle: "아니오", cancleButtonTitle: "네", primaryAction: nil) {
                if mypageStore.currenUser.signInCompany == "카카오톡" {
                    signInStore.kakaoSingOut()
                } else if mypageStore.currenUser.signInCompany == "애플" {
                    signInStore.isSignIn = false
                }
                homeStore.certificates = [Certificate]()
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
            .environment(HomeStore())
            .environment(TabBarStore())
            .environment(SignInStore())
    }
}
