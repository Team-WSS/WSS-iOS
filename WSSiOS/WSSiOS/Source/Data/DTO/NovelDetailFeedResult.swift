//
//  NovelDetailFeedResult.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/26/24.
//

import Foundation

struct NovelDetailFeedResult: Codable {
    let isLoadable: Bool
    let feeds: [TotalFeeds]
}
