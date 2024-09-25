//
//  TotalFeedDTO.swift
//  WSSiOS
//
//  Created by 신지원 on 6/3/24.
//

import Foundation

struct TotalFeed: Codable {
    let category: String
    let isLoadable: Bool
    let feeds: [TotalFeeds]
}

struct TotalFeeds: Codable {
    let userId: Int
    let nickname: String
    let avatarImage: String
    let feedId: Int
    let createdDate: String
    let feedContent: String
    let likeCount: Int
    let isLiked: Bool
    let commentCount: Int
    let novelId: Int
    let title: String
    let novelRatingCount: Int
    let novelRating: Float
    let relevantCategories: [String]
    let isSpolier: Bool
    let isModified: Bool
    let isMyFeed: Bool
}

let dummyFeedImage = "https://d2ur3228349jyd.cloudfront.net/assets/img/common/characters/kuromi.png"
let dummyFeedData = [TotalFeeds(userId: 123,
                                nickname: "지원입니둥",
                                avatarImage: dummyFeedImage,
                                feedId: 846,
                                createdDate: "3월 21일",
                                feedContent: "판소추천해요!",
                                likeCount: 333,
                                isLiked: false,
                                commentCount: 7,
                                novelId: 123,
                                title: "안녕하세요전안안녕한데요?안녕하세요?안녕하신지요?",
                                novelRatingCount: 523,
                                novelRating: 4.0,
                                relevantCategories: ["wuxia", "romance", "wuxia", "romance"],
                                isSpolier: false,
                                isModified: true,
                                isMyFeed: false),
                     TotalFeeds(userId: 123,
                                nickname: "지원입니둥",
                                avatarImage: dummyFeedImage,
                                feedId: 846,
                                createdDate: "3월 21일",
                                feedContent: "배경은 현대아니라 판타지세계라 더 독특해요. 성좌채팅이 있어서 호불호 갈릴 수 있지만 이것도 스토리성이 있는 부분이라 후에 가면",
                                likeCount: 333,
                                isLiked: true,
                                commentCount: 7,
                                novelId: 123,
                                title: "안녕하세요",
                                novelRatingCount: 523,
                                novelRating: 4.0,
                                relevantCategories: ["wuxia", "romance", "wuxia", "romance"],
                                isSpolier: true,
                                isModified: false,
                                isMyFeed: false),
                     TotalFeeds(userId: 123,
                                nickname: "지원입니둥",
                                avatarImage: dummyFeedImage,
                                feedId: 846,
                                createdDate: "3월 21일",
                                feedContent: "쿠로미 짱",
                                likeCount: 333,
                                isLiked: false,
                                commentCount: 7,
                                novelId: 123,
                                title: "안녕하세요",
                                novelRatingCount: 523,
                                novelRating: 4.0,
                                relevantCategories: ["wuxia", "romance", "wuxia", "romance"],
                                isSpolier: false,
                                isModified: false,
                                isMyFeed: false),
                     TotalFeeds(userId: 123,
                                nickname: "지원입니둥",
                                avatarImage: dummyFeedImage,
                                feedId: 846,
                                createdDate: "3월 21일",
                                feedContent: "배경은 현대아니라 판타지세계라 더 독특해요. 성좌채팅이 있어서 호불호 갈릴 수 있지만 이것도 스토리성이 있는 부분이라 후에 가면",
                                likeCount: 333,
                                isLiked: true,
                                commentCount: 7,
                                novelId: 123,
                                title: "안녕하세요",
                                novelRatingCount: 523,
                                novelRating: 4.0,
                                relevantCategories: ["wuxia", "romance", "wuxia", "romance"],
                                isSpolier: false,
                                isModified: false,
                                isMyFeed: false),
                     TotalFeeds(userId: 123,
                                nickname: "지원입니둥",
                                avatarImage: dummyFeedImage,
                                feedId: 846,
                                createdDate: "3월 21일",
                                feedContent: "판소추천해요! 완결난지는 좀 되었는데 추천합니다. scp 같은 이상현상 물품을 모아놓은 창고를 관리하는 주인공입니다. 배경은 현대아니라 판타지세계라 더 독특해요. 성좌채팅이 있어서 호불호 갈릴 수 있지만 이것도 스토리성이 있는 부분이라 후에 가면 판소추천해요! 완결난지는 좀 되었는데 추천합니다. scp 같은 이상현상 물품을 모아놓은 창고를 관리하는 주인공입니다. 배경은 현대아니라 판타지세계라 더 독특해요. 성좌채팅이 있어서 호불호 갈릴 수 있지만 이것도 스토리성이 있는 부분이라 후에 가면",
                                likeCount: 333,
                                isLiked: true,
                                commentCount: 7,
                                novelId: 123,
                                title: "안녕하세요",
                                novelRatingCount: 523,
                                novelRating: 4.0,
                                relevantCategories: ["wuxia", "romance", "wuxia", "romance"],
                                isSpolier: false,
                                isModified: false,
                                isMyFeed: false),
                     TotalFeeds(userId: 123,
                                nickname: "지원입니둥",
                                avatarImage: dummyFeedImage,
                                feedId: 846,
                                createdDate: "3월 21일",
                                feedContent: "판소추천해요! 완결난지는 좀 되었는데 추천합니다. scp 같은 이상현상 물품을 모아놓은 창고를 관리하는 주인공입니다. 배경은 현대아니라 판타지세계라 더 독특해요. 성좌채팅이 있어서 호불호 갈릴 수 있지만 이것도 스토리성이 있는 부분이라 후에 가면 판소추천해요! 완결난지는 좀 되었는데 추천합니다. scp 같은 이상현상 물품을 모아놓은 창고를 관리하는 주인공입니다. 배경은 현대아니라 판타지세계라 더 독특해요. 성좌채팅이 있어서 호불호 갈릴 수 있지만 이것도 스토리성이 있는 부분이라 후에 가면",
                                likeCount: 333,
                                isLiked: true,
                                commentCount: 7,
                                novelId: 123,
                                title: "안녕하세요",
                                novelRatingCount: 523,
                                novelRating: 4.0,
                                relevantCategories: ["wuxia", "romance", "wuxia", "romance"],
                                isSpolier: false,
                                isModified: false,
                                isMyFeed: false),
                     TotalFeeds(userId: 123,
                                nickname: "지원입니둥",
                                avatarImage: dummyFeedImage,
                                feedId: 846,
                                createdDate: "3월 21일",
                                feedContent: "판소추천해요! 완결난지는 좀 되었는데 추천합니다. scp 같은 이상현상 물품을 모아놓은 창고를 관리하는 주인공입니다. 배경은 현대아니라 판타지세계라 더 독특해요. 성좌채팅이 있어서 호불호 갈릴 수 있지만 이것도 스토리성이 있는 부분이라 후에 가면 판소추천해요! 완결난지는 좀 되었는데 추천합니다. scp 같은 이상현상 물품을 모아놓은 창고를 관리하는 주인공입니다. 배경은 현대아니라 판타지세계라 더 독특해요. 성좌채팅이 있어서 호불호 갈릴 수 있지만 이것도 스토리성이 있는 부분이라 후에 가면",
                                likeCount: 333,
                                isLiked: true,
                                commentCount: 7,
                                novelId: 123,
                                title: "안녕하세요",
                                novelRatingCount: 523,
                                novelRating: 4.0,
                                relevantCategories: ["wuxia", "romance", "wuxia", "romance"],
                                isSpolier: false,
                                isModified: false,
                                isMyFeed: false)]

let dummyFeedPageBarTitle = ["판타지", "현판", "무협", "드라마", "미스터리", "라노벨", "로맨스", "로판", "BL", "기타"]
