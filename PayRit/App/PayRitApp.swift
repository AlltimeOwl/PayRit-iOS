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
    
    init() {
        KakaoSDK.initSDK(appKey: "8465cab1fe7ac30a9b0b67cd90db791d")
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
