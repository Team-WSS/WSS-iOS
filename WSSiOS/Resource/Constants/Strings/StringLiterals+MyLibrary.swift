//
//  StringLiterals+MyLibrary.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/25/25.
//

extension StringLiterals {
    enum MyLibrary {
        enum FilterButton {
            static let interest = "관심"
            static let readStatus = "읽기상태"
            static let genre = "장르"
            static let publicationStatus = "연재상태"
            static let starRating = "별점"
            static let ratingEmpty = "별점 없음"
            static let attractivePoint = "매력포인트"
            static let keyword = "키워드"
        }
        
        static func novelCountText(_ count: Int) -> String {
            return "\(count)개"
        }

        enum Sort {
            static let title = "정렬"
        }
        
        enum Filter {
            static let title = "작품 찾기 필터"
            static let readStatus = "읽기 상태"
            static let attractivePoint = "매력포인트"
            static let rating = "별점"

            // 탭 타이틀
            static let tabReadStatus = "읽기상태"
            static let tabGenre = "장르"
            static let tabPublicationStatus = "연재상태"
            static let tabRating = "별점"
            static let tabAttractivePoint = "매력포인트"
            static let tabKeyword = "키워드"

            // 별점 탭
            static let notRatedOnly = "별점 등록 안된 작품만 보기"

            // 키워드 탭
            static func registeredKeywordCount(_ count: Int) -> String {
                if count == 0 {
                    return "등록된 키워드가 없습니다"
                } else {
                    return "등록한 키워드 \(count)개"
                }
            }
        }
        
        enum Empty {
            static let libraryEmpty = "서재가 비어있어요"
            static let searchButton = "웹소설 찾기"
            static let filterResultEmpty = "해당하는 작품이 없어요\n검색의 범위를 더 넓혀보세요"
        }
    }
}
