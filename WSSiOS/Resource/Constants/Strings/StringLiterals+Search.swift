//
//  StringLiterals+Search.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/1/25.
//

import Foundation

extension StringLiterals {
    enum Search {
        static let title = "탐색하기"
        static let searchbar = "작품 제목, 작가를 검색하세요"

        static let recentSearchTitle = "최근 검색어"
        static let deleteAll = "전체삭제"
        static let genreSearchTitle = "장르별 검색"
        
        static let induceTitle = "뭐 읽을지 고민될 땐?"
        static let induceDescription = "장르, 연재상태, 별점, 키워드로 작품 찾기"
        static let induceButton = "내 취향에 맞는 웹소설 찾기"
        
        static let sosoTitle = "소소"
        static let sosoDescription = "다른 독자들이 최근에 찾아본 웹소설이에요"
        
        static let novel = "작품"
        
        static let noSearchResult = "찾는 작품이 없다면?"
        
        enum Empty {
            static let description = "해당 검색어를 가진 작품은\n아직 등록되지 않았어요.."
            static let inquiryButton = "작품 문의하러 가기"
        }
    }
    
    enum DetailSearch {
        static let info = "정보"
        static let keyword = "키워드"
        
        static let genre = "장르"
        
        static let serialStatus = "연재상태"
  
        static let rating = "별점"
        
        static let reload = "초기화"
        static let searchNovel = "작품 찾기"
        
        static let world = "세계관"
        static let subject = "소재"
        static let character = "캐릭터"
        static let relation = "관계"
        static let vibe = "분위기/전개"
        
        static let placeHolder = "키워드를 검색하세요"
        
        static let empty = "해당하는 작품이 없어요\n검색의 범위를 더 넓혀보세요"
        
        static let applyOption = "장르, 연재상태, 별점, 키워드 적용"
        static let applyGenre = "장르 적용"
    }
}
