//
//  MyLibraryResponse.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/27/25.
//

import Foundation

struct MyLibraryListResponse: Decodable {
    let userNovelCount: Int
    let isLoadable: Bool
    let nextCursor: String?
    let userNovels: [MyLibraryResponse]
}

struct MyLibraryResponse: Decodable {
    let userNovelId: Int
    let novelId: Int
    let title: String
    let novelImage: String
    let novelRating: Float
    let readStatus: String?
    let isInterest: Bool
    let userNovelRating: Float
    let attractivePoints: [String]
    let startDate: String?
    let endDate: String?
    let keywords: [String]
    let myFeeds: [String]
}
