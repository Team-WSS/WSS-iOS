//
//  WSSTabBarItem.swift
//  WSSiOS
//
//  Created by 신지원 on 1/7/24.
//

import UIKit

enum WSSTabBarItem: Int, CaseIterable {
    
    case home = 0
    case search, feed, library, myPage
    
    var normalItemImage: UIImage {
        switch self {
        case .home:
            return .icNavigateHome
        case .search:
            return .icNavigateSearch
        case .feed:
            return .icNavigateFeed
        case .library:
            return .icNavigateLibrary
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
        case .library:
            return .icNavigateLibrarySelected
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
        case .library:
            return StringLiterals.Tabbar.Title.libary
        case .myPage:
            return StringLiterals.Tabbar.Title.myPage
        }
    }
    
    func itemViewController() -> UIViewController {
        switch self {
        case .home:
            return HomeViewController(viewModel: HomeViewModel(
                recommendRepository: DefaultRecommendRepository(
                    recommendService: DefaultRecommendService()
                ),
                userRepository: DefaultUserInfoRepository(
                    userService: DefaultUserService()
                ),
                notificationRepository: DefaultNotificationRepository(
                    notificationService: DefaultNotificationService())
            ))
            
        case .search:
            return SearchViewController(viewModel: SearchViewModel(searchRepository: DefaultSearchRepository(searchService: DefaultSearchService())))
            
        case .feed:
            return FeedViewController()
            
        case .library:
            return ModuleFactory.shared.makeMyLibraryViewController()
            
        case .myPage:
            let myPageVC = MyPageViewController(
                viewModel: MyPageViewModel(
                    userRepository: DefaultUserRepository(
                        userInfoRepository: DefaultUserInfoRepository(
                            userService: DefaultUserService()),
                        userBlockRepository: DefaultUserBlockRepository(
                            blocksService: DefaultBlocksService()))))
            return myPageVC
        }
    }
}
