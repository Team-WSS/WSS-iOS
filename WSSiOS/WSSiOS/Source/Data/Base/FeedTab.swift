//
//  FeedTab.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/22/25.
//

enum FeedTab: CaseIterable {
    case my
    case soso
    
    var text: String {
        switch self {
        case .my: "내 피드"
        case .soso: "소소피드"
        }
    }
}

enum SosoFeedTab {
    case all
    case recommended
    
    var text: String {
        switch self {
        case .all: "전체글"
        case .recommended: "추천글"
        }
    }
}

enum FeedPageType: Int, CaseIterable {
    case my = 0
    case sosoAll
    case sosoRecommended

    var feedTab: FeedTab {
        switch self {
        case .my: return .my
        default: return .soso
        }
    }

    var sosoFeedTab: SosoFeedTab? {
        switch self {
        case .sosoAll: return .all
        case .sosoRecommended: return .recommended
        default: return nil
        }
    }
}
