//
//  LibraryFilterChip.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import Foundation

struct LibraryFilterChip: Equatable {
    enum Category: Equatable {
        case readStatus(ReadStatus)
        case genre(NovelGenre)
        case publicationStatus(PublicationStatus)
        case rating
        case attractivePoint(AttractivePoint)
        case keyword(KeywordData)
    }
    
    let category: Category
    let title: String
}
