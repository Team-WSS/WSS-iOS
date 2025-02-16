//
//  NotificationResult.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import Foundation

// 전체 공지사항 조회
struct NotificationsResponse: Decodable {
    var isLoadable: Bool
    var notifications: [NotificationResponse]
}

struct NotificationResponse: Decodable {
    var notificationId: Int
    var notificationImage: String
    var notificationTitle: String
    var notificationBody: String
    var createdDate: String
    var isRead: Bool
    var isNotice: Bool
    var feedId: Int?
}

// 공지사항 상세 조회
struct NotificationDetailResponse: Decodable {
    var notificationTitle: String
    var notificationCreatedDate: String
    var notificationDetail: String
}

// 유저 비열람 알림 존재 여부 조회
struct NotificationUnreadStatusResponse: Decodable {
    var hasUnreadNotifications: Bool
}
