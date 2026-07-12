//
//  SearchFilterOption.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/30/26.
//

import Foundation

struct SearchFilterQuery {
    let keywords: [KeywordData]
    let platforms: [NovelPlatform]
    let genres: [NovelGenre]
    let isCompleted: Bool?
    let lowerNovelRating: Float
    let upperNovelRating: Float
}
