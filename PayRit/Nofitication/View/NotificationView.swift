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
