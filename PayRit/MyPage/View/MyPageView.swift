//
//  MyPageView.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import SwiftUI

struct MyPageView: View {
    @State var name: String = "임대진"
    @State var email: String = "eowls2983@gmail.com"
    @State var listItemHeight: CGFloat = 40
    @State var isShowingSignOut: Bool = false
    @Binding var tabBarVisivility: Visibility
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Circle()
                    .frame(height: 77)
                    .foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: 10) {
                    Text(name)
                        .font(.system(size: 24))
                        .bold()
                    Text(email)
                        .font(.system(size: 16))
                }
                .frame(height: 77)
                Spacer()
            }
            .padding(.horizontal, 16)
            List {
                NavigationLink {
                    MyInfoView()
                        .customBackbutton()
                } label: {
                    Text("계정 정보")
                }
                .frame(height: listItemHeight)
                NavigationLink {
                    
                } label: {
                    Text("결제 내역")
                }
                .frame(height: listItemHeight)
                NavigationLink {
                    
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
            }
            .listStyle(.plain)
            .padding(.top, 30)
            Spacer()
        }
        .toolbar {
            ToolbarItem {
                Text("")
            }
        }
        .PrimaryAlert(isPresented: $isShowingSignOut, title: "로그아웃", content: "로그아웃 하시겠습니까?", primaryButtonTitle: "아니오", cancleButtonTitle: "네", primaryAction: nil) {
            // 로그아웃
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView(tabBarVisivility: .constant(.hidden))
    }
}
