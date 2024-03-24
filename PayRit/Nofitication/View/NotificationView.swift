//
//  NotificationView.swift
//  PayRit
//
//  Created by 임대진 on 3/24/24.
//

import SwiftUI

struct NotificationView: View {
    let notificationStore: NotificationStore = NotificationStore()
    @State var notis: [PayritNoti] = [PayritNoti]()
    @State var test: [PayritNoti] = [PayritNoti(title: "결제요청알림", body: "박이릿님에게 일부 상환 갱신 요청드려요. 받은 금액을 페이릿 상세 페이지에 입력해주세요!"),
                              PayritNoti(title: "승인요청알림", body: "박이릿님에게 차용증 승인 요청을 완료했어요. 승인 재요청을 원하시면 홈 -> 차용증 카드 -> 더보기 버튼을 눌러 재요청해주세요."),
                              PayritNoti(title: "결제요청알림", body: "2월 26일에 작성된 약속에 관한 결제가 진행되지 않았습니다."),
                              PayritNoti(title: "회원가입 알림", body: "페이릿에 오신것을 환영합니다.")]
    var body: some View {
        ZStack {
            Color(hex: "F9F9F9").ignoresSafeArea()
            VStack {
                List {
                    ForEach($notis) { $noti in
                        Button {
                            if !noti.clicked {
                                notificationStore.notiClicked(noti: noti)
                                $noti.clicked.wrappedValue = true
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 0) {
                                    Text(noti.title)
                                        .font(Font.body01)
                                        .foregroundStyle(Color.gray02)
                                    Spacer()
                                    Text(noti.date)
                                        .font(Font.body04)
                                        .foregroundStyle(Color.gray05)
                                }
                                Text(noti.body)
                                    .font(Font.body02)
                                    .foregroundStyle(Color.gray02)
                                    .padding(.top, 8)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .opacity(noti.clicked ? 0.5 : 1)
                        }
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(hex: "F9F9F9"))
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
            }
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.notis = UserDefaultsManager().loadNotifications()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    UserDefaultsManager().notiRemoveAll()
                    self.notis.removeAll()
                } label: {
                    Text("전체삭제")
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NotificationView(notis: [PayritNoti]())
    }
}
