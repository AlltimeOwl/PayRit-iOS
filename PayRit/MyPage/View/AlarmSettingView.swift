//
//  AlarmSettingView.swift
//  PayRit
//
//  Created by 임대진 on 3/12/24.
//

import SwiftUI

struct AlarmSettingView: View {
    @State private var isNotificationEnabled = false
    @State private var payritAlamIsAble: Bool = false
    let mypageStore: MyPageStore
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(spacing: 16) {
                HStack {
                    Text("앱 푸시 알림 설정")
                        .font(.system(size: 18))
                    Spacer()
                        if isNotificationEnabled {
                            Capsule()
                                .frame(width: 50, height: 30)
                                .foregroundStyle(Color.payritMint)
                                .shadow(radius: 0.5)
                                .overlay(alignment: .trailing) {
                                        Circle()
                                            .frame(width: 26)
                                            .foregroundStyle(.white)
                                            .padding(.trailing, 2)
                                            .shadow(radius: 0.5)
                                }
                                .onTapGesture {
                                    openAppSettings()
                                }
                        } else {
                            Capsule()
                                .frame(width: 50, height: 30)
                                .foregroundStyle(Color(hex: "E9E9EB"))
                                .shadow(radius: 0.5)
                                .overlay(alignment: .leading) {
                                        Circle()
                                            .frame(width: 26)
                                            .foregroundStyle(.white)
                                            .padding(.leading, 2)
                                            .shadow(radius: 0.5)
                                }
                                .onTapGesture {
                                    openAppSettings()
                                }
                        }
                }
                .frame(height: 88)
                .padding(.horizontal, 16)
                .background(.white)
                .clipShape(.rect(cornerRadius: 12))
                .customShadow()
                
                HStack {
                    Text("페이릿, 약속 푸시 알림 설정")
                        .font(.system(size: 18))
                    Spacer()
                        if payritAlamIsAble {
                            Capsule()
                                .frame(width: 50, height: 30)
                                .foregroundStyle(Color.payritMint)
                                .shadow(radius: 0.5)
                                .overlay(alignment: .trailing) {
                                        Circle()
                                            .frame(width: 26)
                                            .foregroundStyle(.white)
                                            .padding(.trailing, 2)
                                            .shadow(radius: 0.5)
                                }
                                .onTapGesture {
                                    payritAlamIsAble.toggle()
                                    mypageStore.alamRequest(type: .send) { _ in
                                    }
                                }
                        } else {
                            Capsule()
                                .frame(width: 50, height: 30)
                                .foregroundStyle(Color(hex: "E9E9EB"))
                                .shadow(radius: 0.5)
                                .overlay(alignment: .leading) {
                                        Circle()
                                            .frame(width: 26)
                                            .foregroundStyle(.white)
                                            .padding(.leading, 2)
                                            .shadow(radius: 0.5)
                                }
                                .onTapGesture {
                                    payritAlamIsAble.toggle()
                                    mypageStore.alamRequest(type: .send) { _ in
                                    }
                                }
                        }
                }
                .frame(height: 88)
                .padding(.horizontal, 16)
                .background(.white)
                .clipShape(.rect(cornerRadius: 12))
                .customShadow()
                
                Spacer()
            }
            .dismissOnDrag()
            .navigationTitle("알림 설정")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 28)
            .padding(.horizontal, 16)
            .onAppear {
                checkNotificationAuthorization()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                checkNotificationAuthorization()
            }
        }
        .onAppear {
            mypageStore.alamRequest(type: .load) { result in
                payritAlamIsAble = result
            }
        }
    }
    
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    func checkNotificationAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                withAnimation {
                    self.isNotificationEnabled = settings.authorizationStatus == .authorized
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AlarmSettingView(mypageStore: MyPageStore())
    }
}
