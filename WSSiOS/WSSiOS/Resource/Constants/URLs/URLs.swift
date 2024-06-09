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
        static func getNovelInfo(novelId: Int) -> String {
            return "/novels/\(novelId)"
        }
    }
    
    enum UserNovel {
        static func getUserNovel(userNovelId: Int) -> String {
            return "/user-novels/\(userNovelId)"
        }
        static let getUserNovelList = "/user-novels"
        static func postUserNovel(novelId: Int) -> String {
            return "/user-novels/\(novelId)"
        }
        static func patchUserNovel(userNovelId: Int) -> String {
            return "/user-novels/\(userNovelId)"
        }
        static func deleteUserNovel(userNovelId: Int) -> String {
            return "/user-novels/\(userNovelId)"
        }
    }
    
    enum Memo {
        static func getMemo(memoId: Int) -> String {
            return "/memos/\(memoId)"
        }
        static let getMemoList = "/memos"
        static func postMemo(userNovelId: Int) -> String {
            return "/user-novels/\(userNovelId)/memo"
        }
        static func patchMemo(memoId: Int) -> String {
            return "/memos/\(memoId)"
        }
        static func deleteMemo(memoId: Int) -> String {
            return "/memos/\(memoId)"
        }
    }
    
    enum Avatar {
        static let getAvatarDetail = "/avatars/{avatarId}"
        static let getRepAvatar = "/rep-avatar"
        static let patchRepAvatar = "/rep-avatar"
    }
    
    enum Feed {
        static let getFeeds = "/feeds"
    }
}
