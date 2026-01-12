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
        
        /// Firebase Info 파일 디버그-릴리즈 버전 적용 분기처리
#if DEBUG
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Debug", ofType: "plist")!
#else
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
#endif
        let _: FirebaseOptions? = FirebaseOptions.init(contentsOfFile: filePath)
        
        RxKakaoSDK.initSDK(appKey: APIConstants.kakaoAppKey)
        
        FirebaseApp.configure()
        NotificationHelper.shared.configure()
        
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

// MARK: APNs & FCM

extension AppDelegate {
    
    /// APNs 기기 등록 성공 콜백, Swizzling Off 상태이기 때문에 직접 device토큰을 Messaging에 등록
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("디바이스 토큰 등록 성공: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// APNs 기기 등록 실패 콜백
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("디바이스 토큰 등록 실패: \(error)")
    }
    
    /// FCM에서 수신한 알림 분석 데이터를 Firebase SDK에 전달
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.noData)
    }
}
