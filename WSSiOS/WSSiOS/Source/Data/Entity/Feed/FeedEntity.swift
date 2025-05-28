//
//  FeedEntity.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 3/22/25.
//

import UIKit

struct FeedEntity {
    // 피드 작성 유저 관련
    let userId: Int
    let userNickname: String
    let userProfileImageURL: URL?
    
    // 피드 관련
    let feedId: Int
    let createdDate: String
    let feedContent: String
    let likeCount: Int
    let isLiked: Bool
    let commentCount: Int
    let genreCategories: [String]
    
    // 피드 연결 작품 관련
    let hasLinkedNovel: Bool
    let novelId: Int?
    let novelTitle: String?
    let novelRating: Float?
    let hasUserRating: Bool?
    let novelUserRating: Float?
    let novelAuthor: String?
    let novelGenreImage: UIImage?
    let novelDescription: String?
    let novelThumbnailURL: URL?
    
    let isSpoiler: Bool
    let isModified: Bool
    let isMyFeed: Bool
    let isPublic: Bool
    
    // 피드 첨부 이미지 관련
    let hasImage: Bool
    let imageCount: Int
    let imageURLs: [URL?]
}

extension FeedResponse {
    func toEntity() -> FeedEntity {
        let userProfileImageURL = KingFisherRxHelper.makeImageURLString(path: self.avatarImage)
        let hasLinkedNovel = self.novelId != nil
        let hasImage = self.images.count > 0
        let imageCount = self.images.count
        //let imageURLs: [URL?] = self.images.map { KingFisherRxHelper.makeImageURLString(path: $0) }
        // 테스트용 코드 -> 머지 시 삭제 예정
        let imageURLs: [URL?] = self.images.map { URL(string: $0)! }
        
        let hasUserRating = self.userNovelRating != nil
        let novelGenreImage = NewNovelGenre(rawValue: self.novelGenre ?? "")?.markImage
        let novelThumbnailImageURL = KingFisherRxHelper.makeImageURLString(path: self.novelThumbnailImage ?? "")
        
        return FeedEntity(userId: self.userId,
                          userNickname: self.nickname,
                          userProfileImageURL: userProfileImageURL,
                          feedId: self.feedId,
                          createdDate: self.createdDate,
                          feedContent: self.feedContent,
                          likeCount: self.likeCount,
                          isLiked: self.isLiked,
                          commentCount: self.commentCount,
                          genreCategories: self.relevantCategories,
                          hasLinkedNovel: hasLinkedNovel,
                          novelId: self.novelId,
                          novelTitle: self.title,
                          novelRating: self.novelRating,
                          hasUserRating: hasUserRating,
                          novelUserRating: self.userNovelRating,
                          novelAuthor: self.novelAuthor,
                          novelGenreImage: novelGenreImage,
                          novelDescription: self.novelDescription,
                          novelThumbnailURL: novelThumbnailImageURL,
                          isSpoiler: self.isSpoiler,
                          isModified: self.isModified,
                          isMyFeed: self.isMyFeed,
                          isPublic: self.isPublic,
                          hasImage: hasImage,
                          imageCount: imageCount,
                          imageURLs: imageURLs)
    }
}
