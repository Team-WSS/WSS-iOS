//
//  NovelDetailResult.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import Foundation

struct NovelDetailHeaderResult: Codable {
    let userNovelID: Int?
    let novelTitle, novelImage: String
    let novelGenres: [String]
    let novelGenreImage: String
    let isNovelCompleted: Bool
    let author: String
    let interestCount: Int
    let novelRating: Float
    let novelRatingCount, feedCount: Int
    let userNovelRating: Float
    let readStatus: String?
    let startDate, endDate: String?
    let isUserNovelInterest: Bool
    
    enum CodingKeys: String, CodingKey {
        case userNovelID = "userNovelId"
        case novelTitle, novelImage, novelGenres
        case novelGenreImage
        case isNovelCompleted, author, interestCount, novelRating, novelRatingCount, feedCount, userNovelRating, readStatus, startDate, endDate, isUserNovelInterest
    }
}

extension NovelDetailHeaderResult {
    static let dummyData: [NovelDetailHeaderResult] = [
        NovelDetailHeaderResult(userNovelID: nil,
                                novelTitle: "여자친구로 삼으려고 학생회장을 꼭 닮은 여자아이를 연성했다가 내가 하인이 됐습니다",
                                novelImage: "ImgNovelCoverDummy",
                                novelGenres: ["romanceFantasy", "romance"],
                                novelGenreImage: "icGenreLabelRfDummy",
                                isNovelCompleted: false,
                                author: "이보라",
                                interestCount: 203,
                                novelRating: 4.4,
                                novelRatingCount: 153,
                                feedCount: 52,
                                userNovelRating: 5.0,
                                readStatus: nil,
                                startDate: nil,
                                endDate: nil,
                                isUserNovelInterest: true),
        NovelDetailHeaderResult(userNovelID: nil,
                                novelTitle: "여자친구로 삼으려고 학생회장을 꼭 닮은 여자아이를 연성했다가 내가 하인이 됐습니다",
                                novelImage: "ImgNovelCoverDummy",
                                novelGenres: ["romanceFantasy", "romance"],
                                novelGenreImage: "icGenreLabelRfDummy",
                                isNovelCompleted: false,
                                author: "이보라",
                                interestCount: 203,
                                novelRating: 4.4,
                                novelRatingCount: 153,
                                feedCount: 52,
                                userNovelRating: 5.0,
                                readStatus: "WATCHED",
                                startDate: nil,
                                endDate: nil,
                                isUserNovelInterest: true),
        NovelDetailHeaderResult(userNovelID: 5,
                                novelTitle: "당신의 이해를 돕기 위하여",
                                novelImage: "ImgNovelCoverDummy",
                                novelGenres: ["romanceFantasy", "romance"],
                                novelGenreImage: "icGenreLabelRfDummy",
                                isNovelCompleted: true,
                                author: "이보라",
                                interestCount: 203,
                                novelRating: 4.4,
                                novelRatingCount: 153,
                                feedCount: 52,
                                userNovelRating: 5.0,
                                readStatus: "WATCHED",
                                startDate: "23. 12. 25",
                                endDate: "24. 01. 05",
                                isUserNovelInterest: true),
        NovelDetailHeaderResult(userNovelID: 5,
                                novelTitle: "당신의 이해를 돕기 위하여",
                                novelImage: "ImgNovelCoverDummy",
                                novelGenres: ["romanceFantasy", "romance"],
                                novelGenreImage: "icGenreLabelRfDummy",
                                isNovelCompleted: true,
                                author: "이보라",
                                interestCount: 203,
                                novelRating: 4.4,
                                novelRatingCount: 153,
                                feedCount: 52,
                                userNovelRating: 5.0,
                                readStatus: "WATCHING",
                                startDate: "23. 12. 25",
                                endDate: nil,
                                isUserNovelInterest: true),
        NovelDetailHeaderResult(userNovelID: 5,
                                novelTitle: "당신의 이해를 돕기 위하여",
                                novelImage: "ImgNovelCoverDummy",
                                novelGenres: ["romanceFantasy", "romance"],
                                novelGenreImage: "icGenreLabelRfDummy",
                                isNovelCompleted: true,
                                author: "이보라",
                                interestCount: 203,
                                novelRating: 4.4,
                                novelRatingCount: 153,
                                feedCount: 52,
                                userNovelRating: 5.0,
                                readStatus: "QUIT",
                                startDate: nil,
                                endDate: "24. 01. 05",
                                isUserNovelInterest: true)
        
    ]
}
