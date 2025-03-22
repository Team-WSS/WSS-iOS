//
//  FeedDetailCommentEntity.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 3/22/25.
//

import UIKit

struct FeedCommentsEntity {
    let commentsCount: Int
    let comments: [FeedCommentEntity]
}

extension FeedCommentsResponse {
    func toEntity() -> FeedCommentsEntity {
        return FeedCommentsEntity(commentsCount: self.commentsCount,
                                  comments: self.comments.map { $0.toEntity() })
    }
}

struct FeedCommentEntity {
    let userId: Int
    let userNickname: String
    let userProfileImageURL: URL?
    
    let commentId: Int
    let createdDate: String
    let commentContent: String
    
    let commentType: FeedCommentType
    let isModified: Bool
}

extension FeedCommentResponse {
    func toEntity() -> FeedCommentEntity {
        let userProfileImageURL = KingFisherRxHelper.makeImageURLString(path: self.avatarImage)
        let userNickname = self.userId == -1 ? StringLiterals.FeedDetail.blckedUser : self.nickname
        var commentType: FeedCommentType = .normal
        if self.isBlocked {
            commentType = .blocked
        } else if self.isHidden {
            commentType = .hidden
        } else if self.isSpoiler {
            commentType = .spoiler
        } else if self.isMyComment {
            commentType = .mine
        } else if self.userId == -1 {
            commentType = .deleteUser
        } else {
            commentType = .normal
        }
        
        return FeedCommentEntity(userId: self.userId,
                                 userNickname: userNickname,
                                 userProfileImageURL: userProfileImageURL,
                                 commentId: commentId,
                                 createdDate: self.createdDate,
                                 commentContent: self.commentContent,
                                 commentType: commentType,
                                 isModified: isModified)
    }
}

// 피드 댓글상태에 따른 케이스 분류
enum FeedCommentType {
    case normal
    case mine
    case spoiler
    case blocked
    case hidden
    case deleteUser
    
    func commentContent(originalContent: String) -> String {
        switch self {
        case .normal, .mine, .deleteUser: return originalContent
        case .spoiler: return StringLiterals.FeedDetail.spoilerComment
        case .blocked: return StringLiterals.FeedDetail.blockedComment
        case .hidden: return StringLiterals.FeedDetail.hiddenComment
        }
    }
    
    // 댓글 컨텐츠 텍스트 색상
    var textColor: UIColor {
        switch self {
        case .normal, .mine, .deleteUser: return .wssBlack
        case .spoiler: return .wssSecondary100
        case .blocked, .hidden: return .wssGray200
        }
    }
    
    
    // 댓글 수정됨 표시 여부
    var showModifiedLabel: Bool {
        switch self {
        case .normal, .mine, .spoiler: return false
        case .blocked, .deleteUser, .hidden: return true
        }
    }
    
    // 댓글 드롭다운 버튼 표시 여부
    var showDropdownButton: Bool {
        switch self {
        case .normal, .mine, .spoiler: return true
        case .blocked, .deleteUser, .hidden: return false
        }
    }
}

