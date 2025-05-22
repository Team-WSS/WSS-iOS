//
//  FeedResponse.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/24/24.
//

import Foundation

/// 소소피드 전체 및 단건 조회
struct FeedResponse: Decodable {
    var userId: Int
    var nickname: String
    var avatarImage: String
    
    var feedId: Int
    var createdDate: String
    var feedContent: String
    var likeCount: Int
    var isLiked: Bool
    
    var commentCount: Int
    
    var novelId: Int?
    var title: String?
    var novelRatingCount: Int?
    var novelRating: Float?
    var relevantCategories: [String]
    
    var isSpoiler: Bool
    var isModified: Bool
    var isMyFeed: Bool
    var isPublic: Bool
    
    var images: [String]
}

/// 소소피드 댓글 전체 조회
struct FeedCommentsResponse: Decodable {
    var commentsCount: Int
    var comments: [FeedCommentResponse]
}

struct FeedCommentResponse: Decodable {
    var userId: Int
    var nickname: String
    var avatarImage: String
    var commentId: Int
    var createdDate: String
    var commentContent: String
    var isModified: Bool
    var isMyComment: Bool
    var isSpoiler: Bool
    var isBlocked: Bool
    var isHidden: Bool
}


// MARK: - Test Repository를 위한 Dummy Data

extension FeedResponse {
    static let dummyOneImageData = FeedResponse(userId: 12345,
                                                nickname: "배고픈하이에나",
                                                avatarImage: "",
                                                feedId: 12,
                                                createdDate: "10월 3일",
                                                feedContent: "배고플 땐 너구리",
                                                likeCount: 1,
                                                isLiked: true,
                                                commentCount: 2,
                                                relevantCategories: [],
                                                isSpoiler: false,
                                                isModified: false,
                                                isMyFeed: true,
                                                isPublic: true,
                                                images: ["https://i.pinimg.com/736x/d1/16/6f/d1166fe8e8cbd0f513d58f464ec38458.jpg"])
    
    static let dummyTwoImagesData = FeedResponse(userId: 12345,
                                                 nickname: "배고픈 하이에나",
                                                 avatarImage: "",
                                                 feedId: 12,
                                                 createdDate: "10월 3일",
                                                 feedContent: "배고플 땐 너구리",
                                                 likeCount: 1,
                                                 isLiked: true,
                                                 commentCount: 2,
                                                 relevantCategories: [],
                                                 isSpoiler: false,
                                                 isModified: false,
                                                 isMyFeed: true,
                                                 isPublic: true,
                                                 images: ["https://i.pinimg.com/736x/d1/16/6f/d1166fe8e8cbd0f513d58f464ec38458.jpg",
                                                         "https://i.pinimg.com/736x/bc/ba/b2/bcbab29a5bd96f4268349694b5a50356.jpg"])
    
    static let dummyThreeImagesData = FeedResponse(userId: 12345,
                                               nickname: "배고픈 하이에나",
                                               avatarImage: "",
                                               feedId: 12,
                                               createdDate: "10월 3일",
                                               feedContent: "배고플 땐 너구리",
                                               likeCount: 1,
                                               isLiked: true,
                                               commentCount: 2,
                                               relevantCategories: [],
                                               isSpoiler: false,
                                               isModified: false,
                                               isMyFeed: true,
                                               isPublic: true,
                                               images: ["https://i.pinimg.com/736x/d1/16/6f/d1166fe8e8cbd0f513d58f464ec38458.jpg",
                                                        "https://i.pinimg.com/736x/bc/ba/b2/bcbab29a5bd96f4268349694b5a50356.jpg",
                                                       "https://i.pinimg.com/736x/d4/d5/c0/d4d5c07c9206aa7b7b351e2ac80458bc.jpg"])
    
    static let dummyManyImagesData = FeedResponse(userId: 12345,
                                                  nickname: "배고픈 하이에나",
                                                  avatarImage: "",
                                                  feedId: 12,
                                                  createdDate: "10월 3일",
                                                  feedContent: "배고플 땐 너구리",
                                                  likeCount: 1,
                                                  isLiked: true,
                                                  commentCount: 2,
                                                  novelId: 12,
                                                  title: "웹소설 제목",
                                                  novelRatingCount: 10,
                                                  novelRating: 1.2,
                                                  relevantCategories: [],
                                                  isSpoiler: false,
                                                  isModified: false,
                                                  isMyFeed: true,
                                                  isPublic: true,
                                                  images: ["https://i.pinimg.com/736x/d1/16/6f/d1166fe8e8cbd0f513d58f464ec38458.jpg",
                                                           "https://i.pinimg.com/736x/8d/95/16/8d9516ee19eeba5f601422bb0143d11c.jpg",
                                                           "https://i.pinimg.com/736x/bc/ba/b2/bcbab29a5bd96f4268349694b5a50356.jpg",
                                                           "https://i.pinimg.com/736x/ee/71/9e/ee719e73c2bda47940746d520c3d71e3.jpg",
                                                          "https://i.pinimg.com/736x/d4/d5/c0/d4d5c07c9206aa7b7b351e2ac80458bc.jpg",
                                                          "https://i.pinimg.com/736x/90/a8/3b/90a83b82a938a5c6dbe76b247366d428.jpg"])
}
