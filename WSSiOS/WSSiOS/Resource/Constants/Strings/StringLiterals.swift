//
//  StringLiterals.swift
//  WSSiOS
//
//  Created by 신지원 on 1/7/24.
//

import Foundation

enum StringLiterals {
    enum KeyChain {
        static let deviceIdentifier = "DEVICE_IDENTIFIER"
    }
    
    enum NotificationCenter {
        static let novelReviewKeywordSelected = Notification.Name("novelReviewKeywordSelected")
        static let novelReviewDataSelected = Notification.Name("novelReviewDataSelected")
        static let novelReviewDateRemoved = Notification.Name("novelReviewDateRemoved")
        static let feedEdited = Notification.Name("feedEdited")
        static let novelReviewed = Notification.Name("novelReviewed")
        static let popFeedDetailViewController = Notification.Name("popFeedDetailViewController")
        static let feedNovelConnected = Notification.Name("feedNovelConnected")
        static let blockUser = Notification.Name("blockUser")
        static let pushToUpdateDetailSearchResult = Notification.Name("pushToUpdateDetailSearchResult")
        static let pushToDetailSearchResult = Notification.Name("pushToDetailSearchResult")
        static let changeRepresentativeAvatar = Notification.Name("changeRepresentativeAvatar")
        static let moveToLibraryTab = Notification.Name("moveToLibraryTab")
    }
    
    enum UserDefault {
        static let accessToken = "ACCESS_TOKEN"
        static let refreshToken = "REFRESH_TOKEN"
        static let userId = "USER_ID"
        static let userGender = "USER_GENDER"
        static let userNickname = "USER_NICKNAME"
        static let isRegister = "IS_REGISTER"
        static let showReviewFirstDescription = "SHOW_REVIEW_FIRST_DESCRIPTION"
        static let userBirth = "USER_BIRTH"
    }
    
    enum FCMCenter {
        enum Key {
            static let view = "view"
            static let feedId = "feedId"
            static let notificationId = "notificationId"
        }
        
        enum Value {
            static let feedDetail = "feedDetail"
        }
    }
    
    enum BirthPicker {
        static let title = "출생연도"
        static let completeButton = "완료"
    }
    
    enum ServiceTermAgreement {
        static let title = "웹소소 세계로 들어가는 중..."
        static let description = "아래 약관 내용에 동의 후 서비스 이용이 가능해요"
        static let agreeAllButton = "전체 동의"
        static let bottomButtonNext = "다음으로"
        static let bottomButtonComplete = "완료"
        
        static let alertTitle = "약관 동의가 필요해요!"
        static let alertDesctiption = "더 안전하고 원활한 웹소소를 위해\n업데이트된 약관에 동의해주세요."
        static let alertButton = "동의하러 가기"
    }
    
    enum Loading {
        static let loadingTitle = "로딩 중"
        static let loadingDescription = "잠시만 기다려주세요"
        static let novelTitle = "작품 제목"
        static let novelAuthor = "작품 작가"
        static let novelGenre = "작품 장르"
    }
    
    enum Error {
        static let title = "네트워크 연결에\n실패했어요"
        static let description = "연결 상태를 확인한 후\n다시 시도해 보세요"
        static let refreshButton = "페이지 다시 불러오기"
    }
    
    enum Tabbar {
        enum Title {
            static let home = "홈"
            static let search = "탐색"
            static let feed = "피드"
            static let libary = "서재"
            static let myPage = "My"
        }
    }
    
    enum Navigation {
        enum Title {
            static let library = "서재"
            static let record = "내 기록"
            static let search = "검색"
            static let myPage = "마이페이지"
            static let changeNickname = "닉네임 변경"
            static let feed = "소소피드"
            static let notification = "알림"
            static let editProfile = "프로필 편집"
            static let deleteID = "회원탈퇴"
            static let myPageSetting = "설정"
            static let myPageInfo = "계정설정"
            static let myPageBlockUser = "차단유저 목록"
            static let myPageChangeUserInfo = "성별/나이 변경"
            static let isVisibleProfile = "프로필 공개 설정"
            static let changeAvatar = "프로필 선택"
            static let pushNotification = "알림 설정"
        }
    }
    
    enum Library {
        static let empty = "서재가 비어있어요"
        static let lookForNovel = "웹소설 찾으러 가기"
    }
    
    enum LibraryReadStatus: String, CaseIterable {
        case interst = "INTEREST"
        case watching = "WATCHING"
        case watched = "WATCHED"
        case quit = "QUIT"
    }
    
    enum ReadStatus: String, CaseIterable {
        case all = "ALL"
        case finish = "FINISH"
        case reading = "READING"
        case drop = "DROP"
        case wish = "WISH"
    }
    
    enum Alignment {
        case newest, oldest
        
        var sortType: String {
            switch self {
            case .newest:
                return "NEWEST"
            case .oldest:
                return "OLDEST"
            }
        }
        
        var title: String {
            switch self {
            case .newest:
                return "최신 순"
            case .oldest:
                return "오래된 순"
            }
        }
    }
    
    enum AppMinimumVersion {
        static let title = "업데이트 알림"
        static let content = "웹소소 세계에 변화가 생겼어요!\n지금 업데이트해보세요."
        static let buttonTitle = "업데이트"
        
        static var bundleVersion: String {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        }
        static var appStoreID: String {
            return Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.appStoreID) as? String ?? "Error"
        }
        static let appStoreURL = "itms-apps://itunes.apple.com/kr/app/\(appStoreID)"
    }
}
