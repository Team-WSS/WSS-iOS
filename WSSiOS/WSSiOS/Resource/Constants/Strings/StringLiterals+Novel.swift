//
//  StringLiterals+Novel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/1/25.
//

import Foundation

extension StringLiterals {
    enum NovelDetail {
        enum Setting {
            static let novelDelete = "작품을 서재에서 삭제"
            static let novelEdit = "작품 정보 수정"
        }
        
        enum Header {
            static let complete = "완결작"
            static let inSeries = "연재중"
            static let interest = "관심"
            static let feedWrite = "나도 한마디"
            static let errorReport = "오류 제보"
            static let deleteReview = "평가 삭제"
            static let deleteReviewAlertTitle = "평가를 모두 삭제할까요?"
            static let deleteReviewAlertDescription = "별점, 상태, 날짜, 매력포인트, 키워드\n정보가 사라지고 되돌릴 수 없어요"
            static let deleteCancel = "취소"
            static let deleteAccept = "삭제"
            static let firstReviewDescription = "읽기 상태를 체크하여\n작품을 평가해보세요!"
            
            enum Loading {
                static let novelTitle = "작품 제목"
                static let novelAuthor = "작품 작가"
                static let novelGenre = "작품 장르"
                static let novelInterestCount = "0"
                static let novelRatingCount = "0.0 (0)"
                static let novelFeedCount = "0"
            }
        }
        
        enum Tab {
            static let info = "정보"
            static let feed = "피드"
        }
        
        enum Info {
            static let description = "작품 소개"
            static let platform = "작품 보러가기"
            static let reviewEmpty = "독자들의 평가"
            static let reviewEmptyDescription = "아직 평가가 없어요\n최초로 남겨보세요!"
            static let attractivePoint = "독자들의 감상평"
            static let attractivePointDescription = "(이)가 매력적인 작품이에요"
            static let readStatus = "명이 작품을\n"
            
            enum ReadStatus {
                static let watched = "봤어요"
                static let watching = "같이 보고 있어요"
                static let quit = "하차했어요"
            }
        }
        
        enum Feed {
            static let emptyDescription = "아직 글이 없어요\n최초로 남겨보세요!"
            
            enum Cell {
                static let isModified = "(수정됨)"
                static let isSpoiler = "스포일러가 포함된 글 보기"
            }
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
        }
    }
    
    enum ReviewerStatus: String, CaseIterable {
        case interest = "관심"
        case watching = "보는 중"
        case watched = "봤어요"
        case quit = "하차"
    }
    
    enum NovelReview {
        enum Navigation {
            static let complete = "완료"
        }
        
        enum Status {
            static let watching = "보는 중"
            static let watched = "봤어요"
            static let quit = "하차"
        }
        
        enum Date {
            static let addDate = "날짜 추가"
            static let complete = "완료"
            static let removeDate = "날짜 삭제"
            static let startDate = "시작 날짜"
            static let endDate = "종료 날짜"
        }
        
        enum AttractivePoint {
            static let attractivePoint = "매력포인트"
        }
        
        enum Keyword {
            static let keyword = "키워드"
            static let placeholder = "키워드로 작품을 소개해 봐요"
        }
        
        enum KeywordSearch {
            static let keywordSelect = "키워드 선택"
            static let placeholder = "키워드를 검색하세요"
            static let searchResult = "검색결과"
            static let reset = "초기화"
            static let selectButtonText = "개 선택"
            static let unregisteredKeyword = "해당 키워드는\n아직 등록되지 않았어요.."
            static let contact = "키워드 문의하러 가기"
        }
        
        enum Alert {
            static let titleText = "평가를 그만할까요?"
            static let writeTitle = "계속 작성"
            static let stopTitle = "그만하기"
        }
    }
}
