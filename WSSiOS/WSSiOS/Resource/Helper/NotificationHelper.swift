//
//  NotificationHelper.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/16/25.
//

import UIKit

import Firebase

final class NotificationHelper: NSObject {
    static let shared = NotificationHelper()
    private override init() {
        super.init()
        
        // 알림 및 cloudMessaging Delegate 지정
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }
    
    /// 전체 FCM 초기 설정 (메인 스레드에서 진행되어야 함)
    @MainActor
    func setRemoteNotification() async {
        if await requestNotificationAuthorization() {
            print("알림 권한 허용")
            registerForAPNs()
        } else {
            print("알림 권한 거부")
        }
    }
    
    /// 알림 권한 요청
    private func requestNotificationAuthorization() async -> Bool {
        do {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            return try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
        } catch {
            print(error)
            return false
        }
    }
    
    /// APNs에 기기 등록
    private func registerForAPNs() {
        UIApplication.shared.registerForRemoteNotifications()
    }
}

extension NotificationHelper: UNUserNotificationCenterDelegate {
    
    /// 포그라운드에서 푸시올 때 처리. 알림이 뜨도록 설정함.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler([.sound, .badge, .banner])
    }

    /// 푸쉬 알람을 탭 했을 때 처리. 화면 이동을 여기서 처리함.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
      let userInfo = response.notification.request.content.userInfo
      Messaging.messaging().appDidReceiveMessage(userInfo)

      completionHandler()
    }
}

extension NotificationHelper: MessagingDelegate {
    
    // FCM 토큰이 생성되거나 변경될 때 자동으로 호출되어 클라이언트에 전달해줌.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("Firebase 등록 토큰: \(fcmToken)")
        
        sendFCMTokenToServer(token: fcmToken)
    }

    // 서버로 갱신된 FCM 토큰 전달
    private func sendFCMTokenToServer(token: String) {
       
    }
}
