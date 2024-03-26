//
//  PayRitApp.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import Firebase
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1.0)
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // Setting Up Notifications...
        // 원격 알림 등록
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOption,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // Setting Up Cloud Messaging...
        // 메세징 델리겟
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // fcm 토큰이 등록 되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

@main
struct PayRitApp: App {
    let userDefault = UserDefaultsManager().getUserInfo()
    @State var signInStore: SignInStore = SignInStore()
    @State var homeStore: HomeStore = HomeStore()
    @State var tabStore: TabBarStore = TabBarStore()
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    init() {
        if let APIKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            KakaoSDK.initSDK(appKey: APIKey)
        }
        
        if userDefault.signInCompany == "애플" {
            signInStore.appleAuthCheck()
        } else if userDefault.signInCompany == "카카오톡" {
            signInStore.kakaoAuthCheck()
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

// Cloud Messaging...
extension AppDelegate: MessagingDelegate {
    
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
                    return
                }
        print("토큰을 받았다")
        print(fcmToken)
        UserDefaultsManager().saveFCMtoken(token: fcmToken)
    }
}

// User Notifications...[AKA InApp Notification...]
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 푸시 메세지가 앱이 켜져있을 때 나올떄
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        // Do Something With MSG Data...
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        notiSave(userInfo: userInfo)
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    // 푸시메세지를 받았을 떄
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Do Something With MSG Data...
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        notiSave(userInfo: userInfo)
        
        completionHandler()
    }
    
    func notiSave(userInfo: [AnyHashable: Any]) {
        let userDefault = UserDefaultsManager()
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let body = alert["body"] as? String,
           let title = alert["title"] as? String {
            print("Body: \(body)")
            print("title: \(title)")
            let newNoti = PayritNoti(title: title, body: body)
            var notis = userDefault.loadNotifications()
            
            // 중복 방지
            if !notis.contains(where: { $0.title == newNoti.title && $0.body == newNoti.body }) {
                notis.append(newNoti)
                userDefault.saveNotifications(notis)
            }
        }
    }
}
