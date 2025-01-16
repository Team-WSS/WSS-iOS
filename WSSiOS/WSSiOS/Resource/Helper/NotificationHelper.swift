//
//  NotificationHelper.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/16/25.
//

import UIKit

import UserNotifications

final class NotificationHelper: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationHelper()
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
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
    
    
}
