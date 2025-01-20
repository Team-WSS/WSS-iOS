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
    
    /// 포그라운드에서 푸시 알림이 도착하면 실행됨. 도착한 알람을 어떻게 처리할지 설정
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler([.sound, .badge, .banner])
    }

    /// 앱이 백그라운드나 포그라운드 상태일 때 푸쉬 알람을 탭 하면 호출됨
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        let category = response.notification.request.content.categoryIdentifier
        switch category {
        default: moveToTargetViewController(userInfo)
        }
        
        completionHandler()
    }
    
    func moveToTargetViewController(_ userInfo: [AnyHashable: Any]) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let topViewController = window.rootViewController?.topViewController() else {
            print("최상단 View Controller를 찾지 못했습니다.")
            return
        }
        
        
        let type = userInfo["type"] as? String ?? ""
        
        switch type {
        case "feedDetailView":
            if let feedId = userInfo["feedId"] as? Int {
                topViewController.pushToFeedDetailViewController(feedId: feedId)
            }
        default: break
        }
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
