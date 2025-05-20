//
//  UserPreferenceEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 5/20/25.
//

import Foundation

struct UserNovelPreferenceEntity {
    let attractivePoints: [String]
    let keywords: [KeywordResponse]
    var hasAttractivePoints: Bool { !attractivePoints.isEmpty }
    var hasKeywords: Bool { !keywords.isEmpty }
}

extension UserNovelPreferenceResponse {
    func toEntity() -> UserNovelPreferenceEntity {
        return UserNovelPreferenceEntity(attractivePoints: self.attractivePoints,
                                         keywords: self.keywords)
    }
}

struct UserGenrePreferenceListEntity {
    let genrePreferences: [UserGenrePreferenceEntity]
}

extension UserGenrePreferenceListResponse {
    func toEntity() -> UserGenrePreferenceListEntity {
        return UserGenrePreferenceListEntity(genrePreferences: self.genrePreferences.map { $0.toEntity() })
    }
}

struct UserGenrePreferenceEntity {
    let genreName: String
    let genreImageURL: URL?
    let genreCount: Int
}

extension UserGenrePreferenceResponse {
    func toEntity() -> UserGenrePreferenceEntity {
        return UserGenrePreferenceEntity(genreName: self.genreName,
                                         genreImageURL: self.genreImageURL,
                                         genreCount: self.genreCount)
    }
}
