//
//  PushService.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/20/25.
//

import Foundation

import RxSwift

protocol PushNotificationService {
    func postUserFCMToken(fcmToken: String) -> Single<Void>
}

final class DefaultPushNotificationService: NSObject, Networking { }

extension DefaultPushNotificationService: PushNotificationService {
    func postUserFCMToken(fcmToken: String) -> Single<Void> {
        do {
            let fcmTokenBody = try JSONEncoder().encode(FCMTokenResult(fcmToken: fcmToken))
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.PushNotification.postFcmToken,
                                              headers: APIConstants.accessTokenHeader,
                                              body: fcmTokenBody)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
