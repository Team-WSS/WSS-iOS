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
