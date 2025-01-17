//
//  AppDelegate.swift
//  WSSiOS
//
//  Created by 신지원 on 1/1/24.
//

import UIKit

import Firebase
import FirebaseCore
import RxKakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        RxKakaoSDK.initSDK(appKey: APIConstants.kakaoAppKey)
        
        FirebaseApp.configure()
        Task {
            await setFCM(application)
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: Notification
extension AppDelegate {
    
    @MainActor
    func setFCM(_ application: UIApplication) async {
        setDelegate()
        if await requestNotificationAuthorization() {
            print("알림 권한 허용")
            registerForAPNs(application)
        } else {
            print("알림 권한 거부")
        }
    }
    
    // 알림 및 cloudMessaging Delegate 지정
    func setDelegate() {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }
    
    // 알림 권한 요청
    func requestNotificationAuthorization() async -> Bool {
        do {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            return try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
        } catch {
            return false
        }
    }
    
    // APNs에 기기 등록
    func registerForAPNs(_ application: UIApplication) {
        application.registerForRemoteNotifications()
    }
    
    // APNs 기기 등록 성공 콜백, Swizzling Off로 직접 device토큰을 Messaging에 등록
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("디바이스 토큰 등록 성공: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // APNs 기기 등록 실패 콜백
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("디바이스 토큰 등록 실패: \(error)")
    }
    
    //
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.noData)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("Firebase 등록 토큰: \(fcmToken)")
        
        // 필요 시 서버로 토큰 전송
        sendFCMTokenToServer(token: fcmToken)
    }

    private func sendFCMTokenToServer(token: String) {
        // 서버로 토큰 전송 로직 구현
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}
