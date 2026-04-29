//
//  FeedFilter.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/27/25.
//

import UIKit

enum FeedVisibilityOption: CaseIterable {
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
    
    var opposite: FeedVisibilityOption {
        switch self {
        case .public: return .private
        case .private: return .public
        }
    }
}

struct FeedFilterOption: Equatable {
    var genres: [NovelGenre] = NovelGenre.feedFilterGenres
    var visibilityOptions: [FeedVisibilityOption] = [.public, .private]
}
