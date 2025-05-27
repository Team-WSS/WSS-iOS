//
//  Feed.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/22/25.
//

import UIKit

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

enum FeedVisibilityOption {
    case `public`, `private`
    
    var optionText: String {
        switch self {
        case .public: return "공개글"
        case .private: return "비공개글"
        }
    }
    
    var optionImage: UIImage {
        switch self {
        case .public: return .icEye.withTintColor(.wssGray200)
        case .private: return .icLock.withTintColor(.wssGray200)
        }
    }
}
