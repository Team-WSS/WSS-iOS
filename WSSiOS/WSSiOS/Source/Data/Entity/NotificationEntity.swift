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
    func toEntity() -> NotificationsEntity {
        return NotificationsEntity(isLoadable: self.isLoadable,
                                   notifications: self.notifications.map { $0.toEntity() })
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
    func toEntity() -> NotificationEntity {
        let notificationImageURL = KingFisherRxHelper.makeImageURLString(path: notificationImage) ?? .none
        return NotificationEntity(notificationId: self.notificationId,
                                  notificationImageURL: notificationImageURL,
                                  notificationTitle: self.notificationTitle,
                                  notificationOverview: self.notificationBody,
                                  createdDate: self.createdDate,
                                  isRead: self.isRead,
                                  isNotice: self.isNotice,
                                  feedId: self.feedId)
    }
}


struct NotificationDetailEntity {
    let title: String
    let content: String
    let createdDate: String
}

extension NotificationDetailResult {
    func toEntity() -> NotificationDetailEntity {
        return NotificationDetailEntity(title: self.notificationTitle,
                                        content: self.notificationDetail,
                                        createdDate: self.notificationCreatedDate)
    }
}
