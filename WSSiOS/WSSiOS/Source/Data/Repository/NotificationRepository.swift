//
//  NotificationRepository.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import Foundation

import RxSwift

protocol NotificationRepository {
    func getNotifications(lastNotificationId: Int) -> Observable<NotificationsEntity>
}

struct DefaultNotificationRepository: NotificationRepository {
    
    private var notificationService: NotificationService
    
    private let notificationSize = 20
    
    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }
    
    func getNotifications(lastNotificationId: Int) -> Observable<NotificationsEntity> {
        return notificationService.getNotifications(lastNotificationId: lastNotificationId,
                                                    size: notificationSize)
        .asObservable()
        .flatMap { $0.transform() }
    }
}
