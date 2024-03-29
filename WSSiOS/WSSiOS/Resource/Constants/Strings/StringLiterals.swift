//
//  StringLiterals.swift
//  WSSiOS
//
//  Created by 신지원 on 1/7/24.
//

import Foundation

enum StringLiterals {
    
    enum Loading {
        static let novelTitle = "작품 제목"
        static let novelAuthor = "작가"
    }
    
    enum Tabbar {
        enum Title {
            static let home = "홈"
            static let library = "서재"
            static let record = "기록"
            static let myPage = "MY"
        }
    }
    
    enum Navigation {
        enum Title {
            static let library = "내 서재"
            static let record = "내 기록"
            static let search = "검색"
            static let myPage = "마이페이지"
            static let changeNickname = "닉네임 변경"
            static let myPageInfo = "계정정보 확인"
        }
    }
    
    enum Register {
        enum Normal {
            enum DatePicker {
                static let middle = "~"
                static let start = "시작 날짜"
                static let end = "종료 날짜"
                static let KoreaTimeZone = "ko_KR"
                static let dateFormat = "yyyy-MM-dd"
                static let complete = "완료"
            }
            
            enum SectionTitle {
                static let readStatus = "읽기 상태 *"
                static let readDate = "읽은 날짜"
                static let keyword = "키워드"
                static let plot = "작품 소개"
                static let genre = "장르"
                static let platform = "작품 보러가기"
            }
            
            enum Keyword {
                static let selectButton = "키워드 등록"
            }
            
            enum RegisterButton {
                static let new = "내 서재에 등록"
                static let edit = "수정 완료"
            }
        }
        
        enum Success {
            static let title = "내 서재에 작품이\n성공적으로 등록되었어요!"
            static let lottie = "animationRegistration"
            static let makeMemo = "작품에 메모 남기기"
            static let returnHome = "홈으로 돌아가기"
        }
    }
    
    
    enum MyPage {
        enum Modal {
            static let back = "돌아가기"
            static let baseTitle = "오늘 당신을 만날 걸 알고 있었어"
            static let baseExplanation = "메모를 작성해서 잠금해제 됐어요!"
            static let keepOriginally = "원래대로 유지하기"
            static let changeCharacter = "대표 캐릭터 설정하기"
        }
        
        enum Profile {
            static let registerNovel = "등록 작품"
            static let record = "기록"
        }
        
        enum Character {
            static let select = "캐릭터 선택"
        }
        
        enum Setting: String, CaseIterable {
            case accountInfo = "계정정보 확인"
            case webSoso = "웹소소 인스타 보러가기"
            case termsOfService = "서비스 이용약관"
        }
        
        enum SettingURL {
            static let instaURL = "https://www.instagram.com/websoso_official/"
            static let termsURL = "https://kimmjabc.notion.site/4acd397608c146cbbf8dd4fe11a82e19"
        }
        
        enum ChangeNickname {
            static let complete = "완료"
            static let nickname = "닉네임"
        }
    }
    
    enum Library {
        static let empty = "아직 서재가 비어있네요!"
        static let register = "웹소설 등록하기"
    }
    
    enum Record {
        enum Empty {
            static let description = "읽은 웹소설에 대해\n기록을 남겨볼까요?"
            static let register = "웹소설 기록하기"
        }
    }
    
    enum TabBar: String, CaseIterable {
        case all = "전체"
        case finish = "읽음"
        case reading = "읽는 중"
        case drop = "하차"
        case wish = "읽고 싶음"
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
        
        var lastId: Int {
            switch self {
            case .newest:
                return 999999
            case .oldest:
                return 0
            }
        }
        
        var sizeData: Int {
            return 500
        }
    }
    
    enum NovelDetail {
        enum Memo {
            static let memo = "메모"
            static let noMemo = "아직 작성된 메모가 없어요"
            static let newMemo = "새로운 메모를 작성해보세요"
        }
        
        enum Info {
            static let info = "정보"
            static let rating = "나의 평가"
            static let readStatus = "읽기 상태"
            static let tilde = "~"
            static let startDate = "시작 날짜"
            static let endDate = "읽은 날짜"
            static let keyword = "키워드"
            static let description = "작품 소개"
            static let genre = "장르"
            static let platform = "작품 보러가기"
        }
        
        enum Setting {
            static let novelDelete = "작품을 서재에서 삭제"
            static let novelEdit = "작품 정보 수정"
        }
    }
    
    enum Search {
        enum Empty {
            static let description = "검색 결과가 없어요ㅠ"
            static let register = "등록 문의하기"
        }
    }
    
    enum Memo {
        static let complete = "완료"
        static let edit = "수정"
    }
    
    enum DeletePopup {
        enum MemoEditCancel {
            static let titleText = "작성을 취소할까요?"
            static let descriptionText = "작성 중인 내용이 모두 사라져요!"
        }
        
        enum MemoDelete {
            static let titleText = "메모를 삭제하실 건가요?"
            static let descriptionText = "삭제한 메모는 다시 되돌릴 수 없어요!"
        }
        
        enum NovelDelete {
            static let titleText = "이 작품을 삭제하실 건가요?"
            static let descriptionText = "읽기 정보와 작성한 메모가 모두 사라져요!\n삭제한 내용은 절대 되돌릴 수 없어요ㅠ"
        }
        
        enum DeleteButtonText {
            static let exit = "나가기"
            static let delete = "삭제하기"
        }
        
        enum CancelButtonText {
            static let keepWriting = "계속 작성하기"
            static let cancel = "취소"
        }
    }
}
