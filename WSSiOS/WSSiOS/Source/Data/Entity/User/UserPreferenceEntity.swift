//
//  UserPreferenceEntity.swift
//  WSSiOS
//
//  Created by 신지원 on 5/20/25.
//

import Foundation

struct UserNovelPreferencesEntity {
    let attractivePoints: [String]
    let keywords: [KeywordEntity]
    var hasAttractivePoints: Bool { !attractivePoints.isEmpty }
    var hasKeywords: Bool { !keywords.isEmpty }
}

extension UserNovelPreferencesResponse {
    func toEntity() -> UserNovelPreferencesEntity {
        let makeKeywordEntity = self.keywords.map{ $0.toEntity() }
        return UserNovelPreferencesEntity(attractivePoints: self.attractivePoints,
                                          keywords: makeKeywordEntity)
    }
}

struct UserGenrePreferencesListEntity {
    let genrePreferences: [UserGenrePreferencesEntity]
}

extension UserGenrePreferencesListResponse {
    func toEntity() -> UserGenrePreferencesListEntity {
        return UserGenrePreferencesListEntity(genrePreferences: self.genrePreferences.map { $0.toEntity() })
    }
}

struct UserGenrePreferencesEntity {
    let genreName: String
    let genreImageURL: URL?
    let genreCount: Int
}

extension UserGenrePreferencesResponse {
    func toEntity() -> UserGenrePreferencesEntity {
        let genreImageURL = KingFisherRxHelper.makeImageURLString(path: self.genreImage)
        return UserGenrePreferencesEntity(genreName: self.genreName,
                                          genreImageURL: genreImageURL,
                                          genreCount: self.genreCount)
    }
}
