//
//  WSSTabBarItem.swift
//  WSSiOS
//
//  Created by 신지원 on 1/7/24.
//

import UIKit

enum WSSTabBarItem: CaseIterable {
    
    case home, search, feed, myPage
    
    var normalItemImage: UIImage {
        switch self {
        case .home:
            return .icNavigateHome
        case .search:
            return .icNavigateSearch
        case .feed:
            return .icNavigateFeed
        case .myPage:
            return .icNavigateMy
        }
    }
    
    var selectedItemImage: UIImage {
        switch self {
        case .home:
            return .icNavigateHomeSelected
        case .search:
            return .icNavigateSearchSelected
        case .feed:
            return .icNavigateFeedSelected
        case .myPage:
            return .icNavigateMySelected
        }
    }
    
    var itemTitle: String {
        switch self {
        case .home:
            return StringLiterals.Tabbar.Title.home
        case .search:
            return StringLiterals.Tabbar.Title.search
        case .feed:
            return StringLiterals.Tabbar.Title.feed
        case .myPage:
            return StringLiterals.Tabbar.Title.myPage
        }
    }
    
    var itemViewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController(viewModel: HomeViewModel(recommendRepository: TestRecommendRepository()))
            
        case .search:
            return SearchViewController(viewModel: SearchViewModel(searchRepository: TestSearchRepository()))
            
        case .feed:
            return RecordViewController(
                recordViewModel: RecordViewModel(
                    memoRepository: DefaultMemoRepository(
                        memoService: DefaultMemoService()
                    )
                )
            )
            
        case .myPage:
            return MyPageViewController(
                userRepository: DefaultUserRepository(
                    userService: DefaultUserService()
                ), avatarRepository: DefaultAvatarRepository(
                    avatarService: DefaultAvatarService()
                )
            )
        }
    }
}
