//
//  URLs.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

enum URLs {
    enum User {
        private static let userBasePath = "/users"
        static let getUserInfo = userBasePath + "/info"
        static let patchUserNickname = userBasePath + "/nickname"
        static let getUserNovelStatus = userBasePath + "/user-novel-stats"
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
        static let postFeed = "/feeds"
        static func putFeed(feedId: Int) -> String {
            return "/feeds/\(feedId)"
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
    
    enum MyPage {
        enum Block {
            static let blocks = "/blocks"
            static func userBlocks(blockID: Int) -> String {
                return "/blocks/\(blockID)"
            }
        }
    }

    enum Recommend {
        static let getTodayPopulars = "/novels/popular"
        static let getRealtimePopulars = "/feeds/popular"
        static let getInterestFeeds = "/feeds/interest"
        static let getTasteRecommendNovels = "/novels/taste"
    }
    
    enum Notice {
        static let getNotices = "/notices"
    }
    
    enum Search {
        static let sosoPick = "/soso-picks"
        static let normalSearch = "/novels"
    }
}
