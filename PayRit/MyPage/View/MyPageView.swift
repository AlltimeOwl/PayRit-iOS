//
//  MyPageView.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import SwiftUI

struct MyPageView: View {
    @State var url: String = ""
    @State var listItemHeight: CGFloat = 60
    @State var isShowingSignOut: Bool = false
    @State var isShowingSafariView: Bool = false
    @State var isShowingMailView: Bool = false
    @State var notFoundUser: Bool = false
    @Environment(HomeStore.self) var homeStore
    @Environment(SignInStore.self) var signInStore
    @Environment(TabBarStore.self) var tabStore
    @Environment(MyPageStore.self) var mypageStore
    @EnvironmentObject var iamportStore: IamportStore
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(mypageStore.currentUser.name)
                                .font(Font.title01)
                            Spacer()
                        }
                        if iamportStore.impAuth {
                            HStack(alignment: .bottom, spacing: 4) {
                                NavigationLink {
                                    MyCertInfoView()
                                        .customBackbutton()
                                        .onAppear {
                                            tabStore.tabBarHide = true
                                        }
                                } label: {
                                    Text("본인인증 완료됨")
                                    Image(systemName: "checkmark.seal.fill")
                                }
                            }
                            .font(Font.body02)
                            .foregroundStyle(Color.payritMint)
                        } else {
                            HStack(alignment: .bottom, spacing: 4) {
                                Text("본인인증 미완료")
                                Image(systemName: "checkmark.seal")
                            }
                            .font(Font.body02)
                            .foregroundStyle(Color.payritIntensivePink)
                        }
                        Text(mypageStore.currentUser.email)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.gray05)
                    }
                    .padding(.top, 60)
                    VStack(alignment: .leading, spacing: 0) {
                        NavigationLink {
                            MyInfoView()
                                .customBackbutton()
                                .onAppear {
                                    tabStore.tabBarHide = true
                                }
                        } label: {
                            HStack {
                                Text("계정 정보")
                                Spacer()
                                Image("nextIcon")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color.gray05)
                            }
                        }
                        .frame(height: listItemHeight)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.gray08)
                        
                        NavigationLink {
                            PaymentHistoryView(mypageStore: mypageStore)
                                .customBackbutton()
                                .onAppear {
                                    tabStore.tabBarHide = true
                                }
                        } label: {
                            HStack {
                                Text("결제 내역")
                                Spacer()
                                Image("nextIcon")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color.gray05)
                            }
                        }
                        .frame(height: listItemHeight)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.gray08)
                        
                        NavigationLink {
                            AlarmSettingView(mypageStore: mypageStore)
                                .customBackbutton()
                                .onAppear {
                                    tabStore.tabBarHide = true
                                }
                                .onDisappear {
                                    tabStore.tabBarHide = false
                                }
                        } label: {
                            HStack {
                                Text("알림 설정")
                                Spacer()
                                Image("nextIcon")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color.gray05)
                            }
                        }
                        .frame(height: listItemHeight)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.gray08)
                        
                        Button {
                            url = "https://bit.ly/3PYvBSw"
                        } label: {
                            HStack {
                                Text("공지사항")
                                Spacer()
                                Image("nextIcon")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color.gray05)
                            }
                        }
                        .frame(height: listItemHeight)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.gray08)
                        
                        Button {
                            url = "https://bit.ly/3UrRkVP"
                        } label: {
                            HStack {
                                Text("자주 묻는 질문")
                                Spacer()
                                Image("nextIcon")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color.gray05)
                            }
                        }
                        .frame(height: listItemHeight)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.gray08)
                        
                        Button {
                            url = "https://bit.ly/3xib1WC"
                        } label: {
                            HStack {
                                Text("서비스 이용 약관")
                                Spacer()
                                Image("nextIcon")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color.gray05)
                            }
                        }
                        .frame(height: listItemHeight)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.gray08)
                        
                        HStack {
                            Text("채널톡 문의")
                            Spacer()
                            Link(destination: URL(string: "http://pf.kakao.com/_djxmxiG/chat")!, label: {
                                HStack {
                                    Image("kakaoSignInLogo")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    Text("Payrit")
                                        .opacity(0.85)
                                }
                            })
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color(hex: "#FEE500"))
                                    )
                        }
                        .frame(height: listItemHeight)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.gray08)
                        
                        Button {
                            isShowingSignOut.toggle()
                        } label: {
                            Text("로그아웃")
                                .foregroundStyle(Color.gray06)
                        }
                        .frame(height: listItemHeight)
                    }
                    .font(Font.body02)
                    .foregroundStyle(.black)
                    .disabled(notFoundUser)
                    .padding(.top, 20)
                    
                    VStack {
                        Text("(주) 멋쟁이 사자처럼")
                        Text("사업자 등록번호 264-88-011106 | 대표이사 나성영")
                        Text("서울특별시 종로구 종로3길 17 D타워, 16-17층")
                        Text("고객지원 cs@payrit.info")
                        Text("Copyright ⓒ Payrit All Rights Reserved.")
                        Spacer()
                    }
                    .padding(.top, 10)
                    .font(Font.caption02)
                    .foregroundStyle(Color.gray04)
                    .frame(height: 140)

                    Spacer()
                }
                .navigationTitle("")
                .scrollIndicators(.hidden)
                .padding(.top, 1)
                .padding(.horizontal, 16)
                .onAppear {
                    tabStore.tabBarHide = false
                }
                .onChange(of: url) {
                    if !url.isEmpty {
                        isShowingSafariView.toggle()
                    }
                }
                .fullScreenCover(isPresented: $isShowingSafariView) {
                    if let url = URL(string: url) {
                        SafariView(url: url)
                            .onDisappear {
                                self.url = ""
                            }
                    }
                }
                .primaryAlert(isPresented: $isShowingSignOut, title: "로그아웃", content: "로그아웃 하시겠습니까?", primaryButtonTitle: "아니오", cancleButtonTitle: "네", primaryAction: nil) {
                    if mypageStore.currentUser.signInCompany == "카카오톡" {
                        signInStore.kakaoSingOut()
                    } else if mypageStore.currentUser.signInCompany == "애플" {
                        signInStore.isSignIn = false
                    }
                    homeStore.certificates = [Certificate]()
                    tabStore.selectedTab = .home
            }
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
            .environment(MyPageStore())
    }
}
