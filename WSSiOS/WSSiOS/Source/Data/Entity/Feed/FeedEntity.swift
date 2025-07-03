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
    let novelData: FeedDetailNovelEntity?
    
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
        let hasImage = self.images.count > 0
        let imageCount = self.images.count
        let imageURLs: [URL?] = self.images.map { KingFisherRxHelper.makeImageURLString(path: $0) }

        //novelID 여부로 novelData 바인딩
        let hasLinkedNovel = self.novelId != nil
        let novelData = makeFeedNovelData()
        
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
                          novelData: novelData,
                          isSpoiler: self.isSpoiler,
                          isModified: self.isModified,
                          isMyFeed: self.isMyFeed,
                          isPublic: self.isPublic,
                          hasImage: hasImage,
                          imageCount: imageCount,
                          imageURLs: imageURLs)
    }
}

extension FeedResponse {
    private func makeFeedNovelData() -> FeedDetailNovelEntity? {
            guard let novelId = self.novelId,
                  let title = self.title,
                  let rating = self.novelRating,
                  let genreRaw = self.novelGenre,
                  let genre = NewNovelGenre(rawValue: genreRaw),
                  let description = self.novelDescription,
                  let thumbnailPath = self.novelThumbnailImage,
                  let thumbnailURL = KingFisherRxHelper.makeImageURLString(path: thumbnailPath)
            else { return nil }
            
            //userNovelRating 여부로 feedAuthorData 바인딩
            let hasFeedAuthorRating = self.userNovelRating != nil
            let feedAuthorData = makeFeedAuthorData(hasFeedAuthorRating: hasFeedAuthorRating)
            
            return FeedDetailNovelEntity(
                novelId: novelId,
                novelTitle: title,
                novelRating: rating,
                hasFeedAuthorRating: hasFeedAuthorRating,
                feedAuthorData: feedAuthorData,
                novelGenreImage: genre.markImage,
                novelDescription: description,
                novelThumbnailURL: thumbnailURL
            )
    }
    
    private func makeFeedAuthorData(hasFeedAuthorRating: Bool) -> FeedDetailNovelFeedAuthorEntity? {
        let feedAuthorData = hasFeedAuthorRating ? FeedDetailNovelFeedAuthorEntity(
            feedAuthor: self.nickname,
            feedAuthorRating: self.userNovelRating!
        ) : nil
        return feedAuthorData
    }
}

struct FeedDetailNovelEntity {
    let novelId: Int
    let novelTitle: String
    let novelRating: Float
    let hasFeedAuthorRating: Bool
    let feedAuthorData: FeedDetailNovelFeedAuthorEntity?
    let novelGenreImage: UIImage
    let novelDescription: String
    let novelThumbnailURL: URL?
}

struct FeedDetailNovelFeedAuthorEntity {
    let feedAuthor: String
    let feedAuthorRating: Float
}
