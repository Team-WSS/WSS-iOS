//
//  PushNotificationRepositry.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/20/25.
//

import Foundation

import RxSwift

protocol PushNotificationRepository {
    func postUserFCMToken(fcmToken: String) -> Single<Void>
}

struct DefaultPushNotificationRepository: PushNotificationRepository {
    private var pushNotificationService: PushNotificationService
    
    init(pushNotificationService: PushNotificationService) {
        self.pushNotificationService = pushNotificationService
    }
    
    func postUserFCMToken(fcmToken: String) -> Single<Void> {
        pushNotificationService.postUserFCMToken(fcmToken: fcmToken)
    }
}
