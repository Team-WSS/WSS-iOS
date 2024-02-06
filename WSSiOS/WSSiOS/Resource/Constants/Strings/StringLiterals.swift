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
                static let start = "시작 날짜"
                static let end = "종료 날짜"
            }
            enum SectionTitle {
                static let readStatus = "읽기 상태 *"
                static let readDate = "읽은 날짜"
                static let plot = "작품 소개"
                static let genre = "장르"
                static let platform = "작품 보러가기"
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
    
    enum Alignment {
        static let newest = "최신 순"
        static let oldest = "오래된 순"
    }
}
