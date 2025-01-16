//
//  NotificationEntity.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 1/15/25.
//

import UIKit

import RxSwift

struct NotificationsEntity {
    let isLoadable: Bool
    let notifications: [NotificationEntity]
}

extension NotificationsResult {
    func transform() -> Observable<NotificationsEntity> {
        let notificationsObservable = Observable.from(self.notifications)
            .flatMap { $0.transform() }
            .toArray()
        
        return notificationsObservable.map { notificationEntities in
            NotificationsEntity(
                isLoadable: self.isLoadable,
                notifications: notificationEntities
            )
        }.asObservable()
    }
}

struct NotificationEntity {
    let notificationId: Int
    let notificationImageURL: URL?
    let notificationTitle: String
    let notificationDescription: String
    let createdDate: String
    let isRead: Bool
    let isNotice: Bool
    let feedId: Int?
}

extension NotificationResult {
    func transform() -> Observable<NotificationEntity> {
        return Observable.create { observer in
            let notificationImageURL = KingFisherRxHelper.makeImageURLString(path: notificationImage) ?? .none
            
            let entity = NotificationEntity(notificationId: self.notificationId,
                                            notificationImageURL: notificationImageURL,
                                            notificationTitle: self.notificationTitle,
                                            notificationDescription: self.notificationDescription,
                                            createdDate: self.createdDate,
                                            isRead: self.isRead,
                                            isNotice: self.isNotice,
                                            feedId: self.feedId)
            observer.onNext(entity)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
