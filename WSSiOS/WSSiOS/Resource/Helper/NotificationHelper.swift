//
//  NotificationHelper.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/16/25.
//

import UIKit

import Firebase
import RxSwift

final class NotificationHelper: NSObject {
    static let shared = NotificationHelper()
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    private override init() {
        self.userRepository = DefaultUserRepository(
            userService: DefaultUserService(),
            blocksService: DefaultBlocksService()
        )
        super.init()
    }
    
    /// 알림 및 cloudMessaging Delegate 지정, NotificationHelper 초기 세팅
    /// 메서드를 사용함으로써 싱글톤 인스턴스를 생성
    func configure() {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }
    
    /// 전체 FCM 초기 설정 (메인 스레드에서 진행되어야 함)
    @MainActor
    func setRemoteNotification() async {
        if await requestNotificationAuthorization() {
            print("알림 권한 허용")
        } else {
            print("알림 권한 거부")
        }
        // 권한 여부와 관계없이 알림 설정은 On이라 가정하고 일단 진행. 권한이 없으면 알림 못받으니 괜찮음.
        registerForAPNs()
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
    
    /// 포그라운드에서 푸시 알림이 도착하면 실행됨. 도착한 알림을 어떻게 처리할지 설정
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler([.sound, .badge, .banner])
    }
    
    /// 푸쉬 알림을 탭 하면 호출됨
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
    
    /// userInfo에 담긴 데이터에 따라 최상단 VC에서 화면 이동을 수행함
    private func moveToTargetViewController(_ userInfo: [AnyHashable: Any]) {
        print("GG")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let topViewController = window.rootViewController?.topViewController() else {
            print("최상단 View Controller를 찾지 못했습니다.")
            return
        }
        
        let view = userInfo[StringLiterals.NotificationCenter.Key.view] as? String ?? ""
        
        switch view {
        case StringLiterals.NotificationCenter.Value.feedDetail:
            if let feedIdString = userInfo[StringLiterals.NotificationCenter.Key.feedId] as? String,
               let feedId =  Int(feedIdString) {
                topViewController.pushToFeedDetailViewController(feedId: feedId)
            }
        default: break
        }
    }
}

extension NotificationHelper: MessagingDelegate {
    
    /// FCM 토큰이 생성되거나 변경될 때 자동으로 호출되어 클라이언트에 전달해줌.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("Firebase 등록 토큰: \(fcmToken)")
        
        sendFCMTokenToServer(token: fcmToken)
    }
    
    /// 서버로 갱신된 FCM 토큰 전달
    private func sendFCMTokenToServer(token: String) {
        do {
            let deviceIdentifier = try getOrCreateDeviceIdentifier()
            print("Identifier", deviceIdentifier)
            
            userRepository.postUserFCMToken(fcmToken: token, deviceIdentifier: deviceIdentifier)
                .retry(3)
                .do(onSuccess: { _ in
                    print("웹소소 서버에 fcm 토큰 등록 성공")
                }, onError: { error in
                    print("웹소소 서버에 fcm 토큰 등록 실패")
                    print(error)
                })
                .subscribe()
                .disposed(by: disposeBag)
        } catch {
            print(error)
        }
    }
    
    private func getOrCreateDeviceIdentifier() throws -> String {
        if let previousIdentifier = try? KeychainHelper.shared.read(forKey: StringLiterals.KeyChain.deviceIdentifier) {
            return String(decoding: previousIdentifier, as: UTF8.self)
        } else {
            let deviceIdentifier = UUID().uuidString
            try KeychainHelper.shared.create(
                value: deviceIdentifier,
                forKey: StringLiterals.KeyChain.deviceIdentifier
            )
            return deviceIdentifier
        }
    }
}
