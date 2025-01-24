//
//  NotificationService.swift
//  WSSiOS
//
//  Created by Guryss on 9/3/24.
//

import Foundation

import RxSwift

protocol NotificationService {
    func getNotifications(lastNotificationId: Int, size: Int) -> Single<NotificationsResult>
    func getNotificationDetail(notificationId: Int) -> Single<NotificationDetailResult>
    func getNotificationUnreadStatus() -> Single<NotificationUnreadStatusResult>
    func postNotificationRead(notificationId: Int) -> Single<Void>
    func postUserFCMToken(fcmToken: String, deviceIdentifier: String) -> Single<Void>
    func postUserPushNotificationSetting(isPushEnabled: Bool) -> Single<Void>
    func getUserPushNotificationSetting() -> Single<PushNotificationSettingResult>
}

final class DefaultNoticeService: NSObject, Networking, NotificationService {
    
    private var urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                        delegate: nil,
                                        delegateQueue: nil)
    
    func getNotifications(lastNotificationId: Int, size: Int) -> Single<NotificationsResult> {
        let notificationsQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "lastNotificationId", value: String(describing: lastNotificationId)),
            URLQueryItem(name: "size", value: String(describing: size))
        ]
        
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Notification.getNotifications,
                                              queryItems: notificationsQueryItems,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0, to: NotificationsResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getNotificationDetail(notificationId: Int) -> Single<NotificationDetailResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Notification.getNotificationDetail(notificationId: notificationId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0, to: NotificationDetailResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getNotificationUnreadStatus() -> Single<NotificationUnreadStatusResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Notification.getNotificationUnreadStatus,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0, to: NotificationUnreadStatusResult.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func postNotificationRead(notificationId: Int) -> Single<Void> {
        do {
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Notification.postNotificationRead(notificationId: notificationId),
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
            
        } catch {
            return Single.error(error)
        }
    }
    
    func postUserFCMToken(fcmToken: String, deviceIdentifier: String) -> Single<Void> {
        do {
            let fcmTokenBody = try JSONEncoder().encode(FCMTokenResult(fcmToken: fcmToken,
                                                                       deviceIdentifier: deviceIdentifier))
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Notification.fcmToken,
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
    
    func postUserPushNotificationSetting(isPushEnabled: Bool) -> Single<Void> {
        do {
            let requestBody = try JSONEncoder().encode(PushNotificationSettingResult(isPushEnabled: isPushEnabled))
            let request = try makeHTTPRequest(method: .post,
                                              path: URLs.Notification.pushNotificationSetting,
                                              headers: APIConstants.accessTokenHeader,
                                              body: requestBody)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { _ in }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getUserPushNotificationSetting() -> Single<PushNotificationSettingResult> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Notification.pushNotificationSetting,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0,
                                       to: PushNotificationSettingResult.self)  }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
}
