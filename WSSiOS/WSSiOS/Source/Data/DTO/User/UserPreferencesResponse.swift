//
//  UserP.swift
//  WSSiOS
//
//  Created by 신지원 on 5/20/25.
//

import Foundation

struct UserNovelPreferencesResponse: Decodable {
    let attractivePoints: [String]
    let keywords: [KeywordResponse]
}

struct UserGenrePreferencesListResponse: Decodable {
    let genrePreferences: [UserGenrePreferencesResponse]
}

struct UserGenrePreferencesResponse: Decodable {
    let genreName: String
    let genreImage: String
    let genreCount: Int
}
