//
//  NoticeService.swift
//  WSSiOS
//
//  Created by Guryss on 9/3/24.
//

import Foundation

import RxSwift

protocol NoticeService {
    func getNoticeList() -> Single<Notices>
    func getNotifications(lastNotificationId: Int, size: Int) -> Single<NotificationsResult>
}

final class DefaultNoticeService: NSObject, Networking, NoticeService {
    
    private var urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                        delegate: nil,
                                        delegateQueue: nil)
    
    func getNoticeList() -> Single<Notices> {
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Notice.getNotices,
                                              headers: APIConstants.accessTokenHeader,
                                              body: nil)
            
            NetworkLogger.log(request: request)
            
            return tokenCheckURLSession.rx.data(request: request)
                .map { try self.decode(data: $0, to: Notices.self) }
                .asSingle()
        } catch {
            return Single.error(error)
        }
    }
    
    func getNotifications(lastNotificationId: Int, size: Int) -> Single<NotificationsResult> {
        let notificationsQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "lastNotificationId", value: String(describing: lastNotificationId)),
            URLQueryItem(name: "size", value: String(describing: size))
        ]
        
        do {
            let request = try makeHTTPRequest(method: .get,
                                              path: URLs.Notice.getNotifications,
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
}
