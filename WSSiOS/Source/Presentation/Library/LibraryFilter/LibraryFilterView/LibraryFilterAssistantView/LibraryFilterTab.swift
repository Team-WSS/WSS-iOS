//
//  LibraryFilterTab.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import Foundation

enum LibraryFilterTab: Int, CaseIterable {
    case readStatus
    case genre
    case publicationStatus
    case rating
    case attractivePoint
    case keyword

    var title: String {
        switch self {
        case .readStatus:
            return StringLiterals.MyLibrary.Filter.tabReadStatus
        case .genre:
            return StringLiterals.MyLibrary.Filter.tabGenre
        case .publicationStatus:
            return StringLiterals.MyLibrary.Filter.tabPublicationStatus
        case .rating:
            return StringLiterals.MyLibrary.Filter.tabRating
        case .attractivePoint:
            return StringLiterals.MyLibrary.Filter.tabAttractivePoint
        case .keyword:
            return StringLiterals.MyLibrary.Filter.tabKeyword
        }
    }
}
