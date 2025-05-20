//
//  UserP.swift
//  WSSiOS
//
//  Created by 신지원 on 5/20/25.
//

import Foundation

struct UserNovelPreferenceResponse: Decodable {
    let attractivePoints: [String]?
    let keywords: [KeywordResponse]?
}

struct UserGenrePreferenceListResponse: Decodable {
    let genrePreferences: [UserGenrePreferenceResponse]
}

struct UserGenrePreferenceResponse: Decodable {
    let genreName: String
    let genreImage: String
    let genreCount: Int
}
