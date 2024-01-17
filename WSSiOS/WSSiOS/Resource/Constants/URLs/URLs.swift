//
//  URLs.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

enum URLs {
    enum User {
        static let getUserInfo = "/users/info"
        static let patchUserNickname = "/users/nickname"
    }
    
    enum Recommend {
        static let getRecommendList = "/user-novels/soso-picks"
    }
    
    enum Novel {
        static let getSearchList = "/novels"
        static let getNovelInfo = "/novels/{novelId}"
    }
    
    enum UserNovel {
        static let getUserNovel = "/user-novels/{userNovelId}"
        static let getUserNovelList = "/user-novels"
        static let postUserNovel = "/user-novels/{novelId}"
        static let patchUserNovel = "/user-novels/{userNovelId}"
        static let deleteUserNovel = "/user-novels/{userNovelId}"
    }
    
    enum Memo {
        static let getMemo = "/memos/{memoId}"
        static let getMemoList = "/memos"
        static let postMemo = "/user-novels/{userNovelId}/memo"
        static let patchMemo = "/memos/{memoId}"
        static let deleteMemo = "/memos/{memoId}"
    }
    
    enum Avatar {
        static let getAvatarDetail = "/avatars/{avatarId}"
        static let getRepAvatar = "/rep-avatar"
        static let patchRepAvatar = "/rep-avatar"
    }
}
