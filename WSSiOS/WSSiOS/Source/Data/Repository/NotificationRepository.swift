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
    func getNotificationDetail(notificationId: Int) -> Observable<NotificationDetailEntity>
    func getNotificationUnreadStatus() -> Observable<NotificationUnreadStatusResult>
}

struct TestNotificationRepository: NotificationRepository {
    func getNotifications(lastNotificationId: Int) -> Observable<NotificationsEntity> {
        return Observable.just(NotificationsEntity(isLoadable: false,
                                   notifications: [NotificationEntity(notificationId: 1,
                                                                      notificationImageURL: nil,
                                                                      notificationTitle: "eoqkr",
                                                                      notificationOverview: "dfsa",
                                                                      createdDate: "dfa",
                                                                      isRead: true,
                                                                      isNotice: true,
                                                                      feedId: nil)]))
    }
    
    func getNotificationDetail(notificationId: Int) -> Observable<NotificationDetailEntity> {
        return Observable.just(NotificationDetailEntity(title: "안녕",
                                                        content: "이것은 예시 텍스트입니다. 아무 내용도 담고 있지 않으며 단순히 글의 형식을 채우기 위해 작성된 문장들입니다. 이 글은 아무런 의미도 없으며, 사용자가 원하는 레이아웃이나 디자인을 확인하는 데 목적이 있습니다. 적당한 길이를 가진 텍스트가 필요할 때 활용할 수 있으며, 실제 내용이 추가될 자리를 대체합니다.예를 들어, 여기에는 문단이 어떻게 보일지 확인하기 위한 내용이 들어갈 수 있습니다. 문장은 길거나 짧게 작성될 수 있으며, 사용자가 필요에 따라 수정하여 사용할 수 있습니다. 이 문단은 텍스트의 흐름을 테스트하기 위해 존재합니다.여기 또 다른 문단이 있습니다. 이 문단은 추가적인 공간을 채우는 역할을 하며, 실질적인 정보는 포함되어 있지 않습니다. 이렇게 작성된 더미 텍스트는 다양한 목적으로 사용될 수 있습니다. 예를 들어, 디자인 작업, 편집 연습, 또는 페이지 레이아웃 테스트 등에 유용하게 활용될 수 있습니다.",
                                                        createdDate: "1999년 11월 16일"))
    }
    
    func getNotificationUnreadStatus() -> Observable<NotificationUnreadStatusResult> {
        return Observable.just(NotificationUnreadStatusResult(hasUnreadNotifications: false))
    }
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
        .map { $0.toEntity() }
    }
    
    func getNotificationDetail(notificationId: Int) -> Observable<NotificationDetailEntity> {
        return notificationService.getNotificationDetail(notificationId: notificationId)
            .asObservable()
            .map { $0.toEntity() }
    }
    
    func getNotificationUnreadStatus() -> Observable<NotificationUnreadStatusResult> {
        return notificationService.getNotificationUnreadStatus()
            .asObservable()
    }
}
