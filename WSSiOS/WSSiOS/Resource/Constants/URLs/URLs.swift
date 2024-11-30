//
//  URLs.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

enum URLs {
    enum Auth {
        static let loginWithApple = "/auth/login/apple"
        static let loginWithKakao = "/auth/login/kakao"
        static let reissue = "/reissue"
        static let withdrawId = "/auth/withdraw"
        static let logout = "/auth/logout"
    }
    
    enum Onboarding {
        static let nicknameCheck = "/users/nickname/check"
        static let postProfile = "/users/profile"
    }
    
    enum User {
        private static let userBasePath = "/users"
        static let userme = userBasePath + "/me"
        static let patchUserNickname = userBasePath + "/nickname"
        static func getUserNovelStatus(userId: Int) -> String {
            return "\(userBasePath)/\(userId)/user-novel-stats"
        }
        static let userInfo = userBasePath + "/info"
        static let myProfile = userBasePath + "/my-profile"
        static func novelPreferencesstatic(userId: Int) -> String {
            return "\(userBasePath)/\(userId)/preferences/attractive-points"
        }
        static func genrePreferencesstatic(userId: Int) -> String {
            return "\(userBasePath)/\(userId)/preferences/genres"
        }
        static let editUserProfile = "\(userBasePath)/my-profile"
    }
    
    enum Novel {
        static let getSearchList = "/novels"
        static func getNovelInfo(novelId: Int) -> String {
            return "/novels/\(novelId)"
        }
    }
    
    enum NovelDetail {
        static func novelDetailHeader(novelId: Int) -> String {
            return "/novels/\(novelId)"
        }
        static func novelDetailInfo(novelId: Int) -> String {
            return "/novels/\(novelId)/info"
        }
        static func novelDetailFeed(novelId: Int) -> String {
            return "/novels/\(novelId)/feeds"
        }
        static func novelIsInterest(novelId: Int) -> String {
            return "/novels/\(novelId)/is-interest"
        }
        static func novelReview(novelId: Int) -> String {
            return "/user-novels/\(novelId)"
        }
    }
    
    enum NovelReview {
        static let postNovelReview = "/user-novels"
        static func getNovelReview(novelId: Int) -> String {
            return "/user-novels/\(novelId)"
        }
        static func putNovelReview(novelId: Int) -> String {
            return "/user-novels/\(novelId)"
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
        static let getAvatar = "/avatars"
    }
    
    enum Feed {
        // 전체 피드 조회
        static let getFeeds = "/feeds"
        
        // 단건 피드 조회
        static func getSingleFeed(feedId: Int) -> String {
            return "/feeds/\(feedId)"
        }
        // 단건 피드 내 댓글 조회
        static func getSingleFeedComments(feedId: Int) -> String {
            return "/feeds/\(feedId)/comments"
        }
        
        // 단건 피드 내 좋아요 등록, 삭제
        static func postFeedLike(feedId: Int) -> String {
            return "/feeds/\(feedId)/likes"
        }
        static func deleteFeedLike(feedId: Int) -> String {
            return "/feeds/\(feedId)/likes"
        }
        
        // 댓글 작성, 수정, 삭제
        static func postComment(feedId: Int) -> String {
            return "/feeds/\(feedId)/comments"
        }
        static func putComment(feedId: Int, commentId: Int) -> String {
            return "/feeds/\(feedId)/comments/\(commentId)"
        }
        static func deleteComment(feedId: Int, commentId: Int) -> String {
            return "/feeds/\(feedId)/comments/\(commentId)"
        }
        
        static func postSpoilerFeed(feedId: Int) -> String {
            return "/feeds/\(feedId)/spoiler"
        }
        static func postImpertinenceFeed(feedId: Int) -> String {
            return "/feeds/\(feedId)/impertinence"
        }
        static func deleteFeed(feedId: Int) -> String {
            return "/feeds/\(feedId)"
        }
        
        static func postSpoilerComment(feedId: Int, commentId: Int) -> String {
            return "/feeds/\(feedId)/comments/\(commentId)/spoiler"
        }
        static func postImpertinenceComment(feedId: Int, commentId: Int) -> String {
            return "/feeds/\(feedId)/comments/\(commentId)/impertinence"
        }
    }
    
    enum MyPage {
        enum Block {
            static let blocks = "/blocks"
            static func userBlocks(blockID: Int) -> String {
                return "/blocks/\(blockID)"
            }
        }
        
        enum ProfileVisibility {
            static let isProfileVisibility = "/users/profile-status"
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
        static let detailSearch = "/novels/filtered"
    }
    
    enum Keyword {
        static let searchKeyword = "/keywords"
    }
    
    enum Contact {
        static let kakao = "http://pf.kakao.com/_kHxlWG"
        static let notionForm = "https://websoso.notion.site/144600bd746881d4b012fbaf586c264d"
    }
}
