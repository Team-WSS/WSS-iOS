//
//  Untitled.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/20/25.
//

import Foundation

struct FCMTokenResult: Codable {
    let fcmToken: String
}

struct PushNotificationSettingResult: Codable {
    let isPushEnabled: Bool
}
