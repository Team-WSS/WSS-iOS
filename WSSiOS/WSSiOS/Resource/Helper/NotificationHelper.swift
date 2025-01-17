//
//  NotificationHelper.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/16/25.
//

import UIKit

import Firebase

final class NotificationHelper: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationHelper()
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }
    
    // 알림 권한 요청 및 APNs에 Notifications 등록(메인 스레드)
    @MainActor
    func requestAuthorization(application: UIApplication) async {
        do {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
            
            if granted {
                print("알림 권한 허용")
                application.registerForRemoteNotifications()
            } else {
                print("알림 권한 거절")
            }
        } catch {
            print("알림 권한 설정 중 오류 발생")
            print(error)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo

      Messaging.messaging().appDidReceiveMessage(userInfo)

      // Change this to your preferred presentation option
      completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo

      Messaging.messaging().appDidReceiveMessage(userInfo)

      completionHandler()
    }
}


extension NotificationHelper: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🟢", #function, fcmToken)
            guard let fcmToken = fcmToken else {
                print("FCM 등록 토큰을 가져오지 못했습니다.")
                return
            }
            print("FCM 등록 토큰: \(fcmToken)")
        }
}
