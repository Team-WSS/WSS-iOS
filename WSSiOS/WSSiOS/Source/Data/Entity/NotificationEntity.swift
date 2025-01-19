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
        }
        .asObservable()
    }
}

struct NotificationEntity {
    let notificationId: Int
    let notificationImageURL: URL?
    let notificationTitle: String
    let notificationOverview: String
    let createdDate: String
    let isRead: Bool
    let isNotice: Bool
    let feedId: Int?
}

extension NotificationResult {
    func transform() -> Observable<NotificationEntity> {
        let notificationImageURL = KingFisherRxHelper.makeImageURLString(path: notificationImage) ?? .none
        let entity = NotificationEntity(notificationId: self.notificationId,
                                        notificationImageURL: notificationImageURL,
                                        notificationTitle: self.notificationTitle,
                                        notificationOverview: self.notificationBody,
                                        createdDate: self.createdDate,
                                        isRead: self.isRead,
                                        isNotice: self.isNotice,
                                        feedId: self.feedId)
        return Observable.just(entity)
    }
}


struct NotificationDetailEntity {
    let title: String
    let content: String
    let createdDate: String
}

extension NotificationDetailResult {
    func transform() -> Observable<NotificationDetailEntity> {
        let entity = NotificationDetailEntity(title: self.notificationTitle,
                                              content: self.notificationDetail,
                                              createdDate: self.notificationCreatedDate)
        return Observable.just(entity)
    }
}
