//
//  PayRitApp.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            Thread.sleep(forTimeInterval: 1.0)
            return true
    }
}

@main
struct PayRitApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @State var signInStore: SignInStore = SignInStore()
    @State var homeStore: HomeStore = HomeStore()
    @State var tabStore: TabBarStore = TabBarStore()
    init() {
        KakaoSDK.initSDK(appKey: "804faa43c8ef17f50ff27c0df82defbf")
        
        if UserDefaultsManager().getUserInfo().signInCompany == "애플" {
            signInStore.appleAuthCheck()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(signInStore)
                .environment(homeStore)
                .environment(tabStore)
        }
    }
}
