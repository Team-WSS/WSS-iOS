//
//  NoticeResult.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import Foundation

struct Notices: Codable {
    var notices: [Notice]
}

struct Notice: Codable {
    var noticeTitle: String
    var noticeContent: String
    var createdDate: String
}

struct NotificationsResult: Decodable {
    var isLoadable: Bool
    var notifications: [NotificationResult]
}

struct NotificationResult: Decodable {
    var notificationId: Int
    var notificationImage: String
    var notificationTitle: String
    var notificationDescription: String
    var createdDate: String
    var isRead: Bool
    var isNotice: Bool
    var feedId: Int?
}
