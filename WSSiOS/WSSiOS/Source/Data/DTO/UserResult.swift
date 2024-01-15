//
//  UserDTO.swift
//  WSSiOS
//
//  Created by 신지원 on 1/15/24.
//

import Foundation

public struct UserResult: Decodable {
    public let representativeAvatarGenreBadge,
               representativeAvatarTag,
               representativeAvatarLineContent,
               representativeAvatarImg,
               userNickName: String
    public let representativeAvatarId, 
               userNovelCount,
               memoCount: Int
    
    init(representativeAvatarGenreBadge: String, representativeAvatarTag: String, representativeAvatarLineContent: String, representativeAvatarImg: String, userNickName: String, representativeAvatarId: Int, userNovelCount: Int, memoCount: Int) {
        self.representativeAvatarGenreBadge = representativeAvatarGenreBadge
        self.representativeAvatarTag = representativeAvatarTag
        self.representativeAvatarLineContent = representativeAvatarLineContent
        self.representativeAvatarImg = representativeAvatarImg
        self.userNickName = userNickName
        self.representativeAvatarId = representativeAvatarId
        self.userNovelCount = userNovelCount
        self.memoCount = memoCount
    }
}
