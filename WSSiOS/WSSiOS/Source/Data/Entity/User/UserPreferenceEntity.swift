//
//  UserPreferenceEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 3/19/25.
//

import Foundation

struct UserNovelPreferenceEntity {
    let attractivePoints: [String]?
    let keywords: [KeywordResponse]?
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
    let genreImage: String
    let genreCount: Int
}

extension UserGenrePreferenceResponse {
    func toEntity() -> UserGenrePreferenceEntity {
        return UserGenrePreferenceEntity(genreName: self.genreName,
                                         genreImage: self.genreImage,
                                         genreCount: self.genreCount)
    }
}
