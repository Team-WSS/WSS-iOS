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
    
    func itemViewController(isLoggedIn: Bool) -> UIViewController {
        switch self {
        case .home:
            return HomeViewController(viewModel: HomeViewModel(recommendRepository: DefaultRecommendRepository(recommendService: DefaultRecommendService()), isLoggedIn: isLoggedIn), isLoggedIn: isLoggedIn)
            
        case .search:
            return SearchViewController(viewModel: SearchViewModel(searchRepository: DefaultSearchRepository(searchService: DefaultSearchService())))
            
        case .feed:
            return FeedViewController()
            
        case .myPage:
            return MyPageViewController(
                viewModel: MyPageViewModel(
                    userRepository: DefaultUserRepository(
                        userService: DefaultUserService(),
                        blocksService: DefaultBlocksService())),
                isMyPage: true)
        }
    }
}
