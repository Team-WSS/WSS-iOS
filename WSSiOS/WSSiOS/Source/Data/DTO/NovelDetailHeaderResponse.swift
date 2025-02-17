//
//  NovelDetailResult.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import Foundation

struct NovelDetailHeaderResponse: Codable {
    let userNovelID: Int?
    let novelTitle, novelImage: String
    let novelGenres: String
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

extension NovelDetailHeaderResponse {
    static let dummyReviewEmptyData: [NovelDetailHeaderResponse] = [
        NovelDetailHeaderResponse(userNovelID: nil,
                                novelTitle: "여자친구로 삼으려고 학생회장을 꼭 닮은 여자아이를 연성했다가 내가 하인이 됐습니다",
                                novelImage: "https://i.pinimg.com/474x/12/82/4b/12824bae93318692634d3bf0f4a4fe13.jpg",
                                novelGenres: "로판/로맨스",
                                novelGenreImage: "/icGenre/romance",
                                isNovelCompleted: false,
                                author: "이보라",
                                interestCount: 203,
                                novelRating: 4.4,
                                novelRatingCount: 153,
                                feedCount: 52,
                                userNovelRating: 0.0,
                                readStatus: nil,
                                startDate: nil,
                                endDate: nil,
                                isUserNovelInterest: false),
        NovelDetailHeaderResponse(userNovelID: nil,
                                novelTitle: "여자친구로 삼으려고 학생회장을 꼭 닮은 여자아이를 연성했다가 내가 하인이 됐습니다",
                                novelImage: "https://i.pinimg.com/474x/12/82/4b/12824bae93318692634d3bf0f4a4fe13.jpg",
                                novelGenres:"로판/로맨스",
                                novelGenreImage: "/icGenre/romance",
                                isNovelCompleted: false,
                                author: "이보라",
                                interestCount: 203,
                                novelRating: 4.4,
                                novelRatingCount: 153,
                                feedCount: 52,
                                userNovelRating: 0.0,
                                readStatus: nil,
                                startDate: nil,
                                endDate: nil,
                                isUserNovelInterest: true)
    ]
    
    static let dummyDateEmptyData: [NovelDetailHeaderResponse] = [
        NovelDetailHeaderResponse(userNovelID: nil,
                                novelTitle: "여자친구로 삼으려고 학생회장을 꼭 닮은 여자아이를 연성했다가 내가 하인이 됐습니다",
                                novelImage: "https://i.pinimg.com/474x/12/82/4b/12824bae93318692634d3bf0f4a4fe13.jpg",
                                novelGenres: "로판/로맨스",
                                novelGenreImage: "/icGenre/romance",
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
        NovelDetailHeaderResponse(userNovelID: nil,
                                novelTitle: "여자친구로 삼으려고 학생회장을 꼭 닮은 여자아이를 연성했다가 내가 하인이 됐습니다",
                                novelImage: "https://i.pinimg.com/474x/12/82/4b/12824bae93318692634d3bf0f4a4fe13.jpg",
                                novelGenres: "로판/로맨스",
                                novelGenreImage: "/icGenre/romance",
                                isNovelCompleted: false,
                                author: "이보라",
                                interestCount: 203,
                                novelRating: 4.4,
                                novelRatingCount: 153,
                                feedCount: 52,
                                userNovelRating: 4.0,
                                readStatus: "WATCHED",
                                startDate: nil,
                                endDate: nil,
                                isUserNovelInterest: true),
        NovelDetailHeaderResponse(userNovelID: nil,
                                novelTitle: "여자친구로 삼으려고 학생회장을 꼭 닮은 여자아이를 연성했다가 내가 하인이 됐습니다",
                                novelImage: "https://i.pinimg.com/474x/12/82/4b/12824bae93318692634d3bf0f4a4fe13.jpg",
                                novelGenres: "로판/로맨스",
                                novelGenreImage: "/icGenre/romance",
                                isNovelCompleted: false,
                                author: "이보라",
                                interestCount: 203,
                                novelRating: 4.4,
                                novelRatingCount: 153,
                                feedCount: 52,
                                userNovelRating: 3.0,
                                readStatus: "WATCHING",
                                startDate: nil,
                                endDate: nil,
                                isUserNovelInterest: true),
        NovelDetailHeaderResponse(userNovelID: nil,
                                novelTitle: "여자친구로 삼으려고 학생회장을 꼭 닮은 여자아이를 연성했다가 내가 하인이 됐습니다",
                                novelImage: "https://i.pinimg.com/474x/12/82/4b/12824bae93318692634d3bf0f4a4fe13.jpg",
                                novelGenres: "로판/로맨스",
                                novelGenreImage: "/icGenre/romance",
                                isNovelCompleted: false,
                                author: "이보라",
                                interestCount: 203,
                                novelRating: 4.4,
                                novelRatingCount: 153,
                                feedCount: 52,
                                userNovelRating: 2.5,
                                readStatus: "QUIT",
                                startDate: nil,
                                endDate: nil,
                                isUserNovelInterest: false)
    ]
    static let dummyFullData: [NovelDetailHeaderResponse] = [
        NovelDetailHeaderResponse(userNovelID: 5,
                                novelTitle: "당신의 이해를 돕기 위하여",
                                novelImage: "https://i.pinimg.com/474x/12/82/4b/12824bae93318692634d3bf0f4a4fe13.jpg",
                                novelGenres: "로판/로맨스",
                                novelGenreImage: "/icGenre/romance",
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
        NovelDetailHeaderResponse(userNovelID: 5,
                                novelTitle: "당신의 이해를 돕기 위하여",
                                novelImage: "https://i.pinimg.com/474x/12/82/4b/12824bae93318692634d3bf0f4a4fe13.jpg",
                                novelGenres:"로판/로맨스",
                                novelGenreImage: "/icGenre/romance",
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
        NovelDetailHeaderResponse(userNovelID: 5,
                                novelTitle: "당신의 이해를 돕기 위하여",
                                novelImage: "https://i.pinimg.com/474x/12/82/4b/12824bae93318692634d3bf0f4a4fe13.jpg",
                                novelGenres: "로판/로맨스",
                                novelGenreImage: "/icGenre/romance",
                                isNovelCompleted: true,
                                author: "이보라",
                                interestCount: 203,
                                novelRating: 4.4,
                                novelRatingCount: 153,
                                feedCount: 52,
                                userNovelRating: 2.5,
                                readStatus: "QUIT",
                                startDate: nil,
                                endDate: "24. 01. 05",
                                isUserNovelInterest: false)
    ]
}
