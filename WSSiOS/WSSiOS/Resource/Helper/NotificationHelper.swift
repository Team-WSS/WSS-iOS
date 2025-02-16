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
    private let notificationRepository: NotificationRepository
    private let disposeBag = DisposeBag()
    
    private override init() {
        self.notificationRepository = DefaultNotificationRepository(
            notificationService: DefaultNoticeService()
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
    
    func checkNotificationAuthorizationStatus() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            Task {
                let settings = await UNUserNotificationCenter.current().notificationSettings()
                let isAuthorized = settings.authorizationStatus == .authorized
                observer.onNext(isAuthorized)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func moveToDeviceSettingApp() {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettingsURL) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            } else {
                print("설정 앱을 열 수 없음")
            }
        }
    }
}

extension NotificationHelper: UNUserNotificationCenterDelegate {
    
    /// 포그라운드에서 푸시 알림이 도착하면 실행됨. 도착한 알림을 어떻게 처리할지 설정
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("푸시알림 수신됨")
        
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
        print("푸시알림 탭 됨")
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
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let topViewController = window.rootViewController?.topViewController() else {
            print("최상단 View Controller를 찾지 못했습니다.")
            return
        }
        
        let view = userInfo[StringLiterals.FCMCenter.Key.view] as? String ?? ""
        
        switch view {
        case StringLiterals.FCMCenter.Value.feedDetail:
            if let feedIdString = userInfo[StringLiterals.FCMCenter.Key.feedId] as? String,
               let feedId = Int(feedIdString) {
                postNotificationRead(userInfo)
                topViewController.pushToFeedDetailViewController(feedId: feedId)
            }
        default: break
        }
    }
    
    func postNotificationRead(_ userInfo: [AnyHashable: Any]) {
        if let notificationIdString = userInfo[StringLiterals.FCMCenter.Key.notificationId] as? String,
           let notificationId = Int(notificationIdString) {
            notificationRepository.postNotificationRead(notificationId: notificationId)
                .do(onNext: { _ in
                    print("알림 읽기 처리 성공!")
                },onError: { error in
                    print("알림 읽기 처리 실패")
                    print(error)
                })
                .subscribe()
                .disposed(by: disposeBag)
        }
    }
}

extension NotificationHelper: MessagingDelegate {
    
    /// FCM 토큰이 생성되거나 변경될 때 자동으로 호출되어 클라이언트에 전달해줌.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let newFCMToken = fcmToken else { return }
        print("새로 갱신된 FCM 토큰: \(newFCMToken)")
        
        if APIConstants.isLogined {
            sendFCMTokenToServer(token: newFCMToken)
        }
    }
    
    /// 최신 FCM 토큰을 직접 갱신
    func fetchFCMToken() {
        Messaging.messaging().token { [weak self] token, error in
            if let error = error {
                print("FCM 토큰 가져오기 실패: \(error.localizedDescription)")
            } else if let token = token {
                print("최신 FCM 토큰: \(token)")
                if APIConstants.isLogined {
                    self?.sendFCMTokenToServer(token: token)
                }
            }
        }
    }
    
    /// 서버로 갱신된 FCM 토큰 전달
    private func sendFCMTokenToServer(token: String) {
        do {
            let deviceIdentifier = try getOrCreateDeviceIdentifier()
            print("Identifier", deviceIdentifier)
            
            notificationRepository.postUserFCMToken(fcmToken: token, deviceIdentifier: deviceIdentifier)
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
    
    /// 디바이스 구분값을 조회하고, 없으면 새로 생성해 저장하고 반환한다.
    private func getOrCreateDeviceIdentifier() throws -> String {
        if let previousIdentifier = try? KeychainHelper.shared.readString(forKey: StringLiterals.KeyChain.deviceIdentifier) {
            return previousIdentifier
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
