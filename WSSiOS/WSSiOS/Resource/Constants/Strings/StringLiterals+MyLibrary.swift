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
            static let starRating = "별점"
            static let attractivePoint = "매력포인트"
        }
        
        static func novelCountText(_ count: Int) -> String {
            return "\(count)개"
        }
        
        enum Filter {
            static let title = "작품 찾기 필터"
            static let readStatus = "읽기 상태"
            static let attractivePoint = "매력포인트"
            static let rating = "별점"
        }
        
        enum Empty {
            static let libraryEmpty = "서재가 비어있어요"
            static let searchButton = "웹소설 찾으러 가기"
            static let filterResultEmpty = "해당하는 작품이 없어요\n검색의 범위를 더 넓혀보세요"
        }
    }
}
