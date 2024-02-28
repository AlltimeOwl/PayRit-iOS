//
//  PayRitApp.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        // 원하는 시간만큼 sleep 시키기( 초 단위 )
//        Thread.sleep(forTimeInterval: 10)
//        return true
//    }
//}

@main
struct PayRitApp: App {
    let signInStore = SignInStore()
    @State var isLaunching: Bool = true
    @State private var isSignInViewVisible = false
    
    init() {
        KakaoSDK.initSDK(appKey: "8465cab1fe7ac30a9b0b67cd90db791d")
        
    }
    
    var body: some Scene {
        WindowGroup {
            // onOpenURL()을 사용해 커스텀 URL 스킴 처리
            if isLaunching {
                LaunchScreenView()
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            isLaunching = false
                        }
                    }
            } else {
                SignInView(singInStore: signInStore).onOpenURL(perform: { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
                .transition(.opacity.animation(.easeIn))
//                LaunchScreenTest()
            }
        }
    }
}

struct LaunchScreenView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIStoryboard(name: "Launch Screen", bundle: nil).instantiateInitialViewController()!
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
