//
//  TotalFeedDTO.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
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

let dummyImage = "data:image/jpeg;base64,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"
let dummy = [TotalFeeds(userId: 123,
                        nickname: "지원입니둥",
                        avatarImage: dummyImage,
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
                        avatarImage: dummyImage,
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
                        avatarImage: dummyImage,
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
                        avatarImage: dummyImage,
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
                        avatarImage: dummyImage,
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
                        avatarImage: dummyImage,
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
                        avatarImage: dummyImage,
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
