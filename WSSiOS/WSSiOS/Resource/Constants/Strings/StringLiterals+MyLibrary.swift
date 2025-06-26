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
            return "\(count)개의 기록"
        }
        
        enum Filter {
            static let title = "작품 찾기 필터"
        }
    }
}
