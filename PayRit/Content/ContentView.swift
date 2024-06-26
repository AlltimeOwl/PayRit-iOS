//
//  ContentView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseAnalytics

struct ContentView: View {
    let userDefault = UserDefaultsManager()
    @State var versionService = VersionService()
    @State private var isShowingReloginAlert: Bool = false
    @Environment(SignInStore.self) var signInStore
    @Environment(MyPageStore.self) var mypageStore
    @EnvironmentObject var iamportStore: IamportStore
    @State var test = false
    var body: some View {
        VStack {
            if signInStore.isSignIn {
                CustomTabView()
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        Task {
                            await userDefault.getUserInfoAsync()
                            if let user = userDefault.user {
                                if user.signInCompany == "애플" {
                                    signInStore.appleAuthCheck()
                                    print("foreground 애플 auth check")
                                } else if user.signInCompany == "카카오톡" {
                                    AuthApi.shared.refreshToken { _, error in
                                        signInStore.kakaoAuthCheck()
                                        print("foreground 카카오 auth check")
                                        if let error = error {
                                            print("foreground 카카오 error : \(error.localizedDescription)")
                                        }
                                    }
                                }
                            }
                        }
                        checkNewVersion()
                        Analytics.logEvent("visit_PayRit_iOS", parameters: [:])
                    }
                    .onAppear {
                        Task {
                            await userDefault.getUserInfoAsync()
                            if let user = userDefault.user {
                                if user.signInCompany == "애플" {
                                    mypageStore.currentUser = userDefault.getAppleUserInfo()
                                } else if user.signInCompany == "카카오톡" {
                                    mypageStore.currentUser = userDefault.getUserInfo()
                                }
                            }
                            if !userDefault.getAuthState() {
                                iamportStore.checkIMPAuth {
                                }
                            }
                        }
                        checkNewVersion()
                    }

            } else {
                SignInView()
                    .onOpenURL(perform: { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
                .onAppear {
                    checkNewVersion()
                }
            }
        }
        .onChange(of: signInStore.isSignIn) {
            if signInStore.isSignIn {
                iamportStore.checkIMPAuth {
                }
            }
        }
        .primaryAlertNoneTouch(isPresented: $versionService.isShowingForceAlert, title: "필수 업데이트 알림", content: "새 버전이 있습니다.\n업데이트 후 사용 가능합니다.", primaryButtonTitle: nil, cancleButtonTitle: "앱스토어 이동") {
        } cancleAction: {
            if let url = URL(string: versionService.appStoreOpenUrlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        .primaryAlertNoneTouch(isPresented: $versionService.isShowingSelectAlert, title: "업데이트 알림", content: "새 버전이 있습니다.\n앱스토어로 이동하시겠습니까?", primaryButtonTitle: "네", cancleButtonTitle: "다음에") {
            if let url = URL(string: versionService.appStoreOpenUrlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } cancleAction: {
        }
    }
    
    func checkNewVersion() {
        versionService.loadAppStoreVersion { [self] latestVersion in
            guard let latestVersion else { return }
            let result = versionService.calVersion(now: versionService.nowVersion(), store: latestVersion)
            switch result {
            case .force:
                versionService.isShowingForceAlert = true
            case .select:
                versionService.isShowingSelectAlert = true
            case .latest:
                break
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(SignInStore())
}
