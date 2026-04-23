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
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssGray200)
        case .search:
            return .icNavigateSearch
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssGray200)
        case .feed:
            return .icNavigateFeed
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssGray200)
        case .library:
            return .icNavigateLibrary
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssGray200)
        case .myPage:
            return .icNavigateMy
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssGray200)
        }
    }
    
    var selectedItemImage: UIImage {
        switch self {
        case .home:
            return .icNavigateHomeSelected
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssBlack)
        case .search:
            return .icNavigateSearchSelected
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssBlack)
        case .feed:
            return .icNavigateFeedSelected
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssBlack)
        case .library:
            return .icNavigateLibrarySelected
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssBlack)
        case .myPage:
            return .icNavigateMySelected
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssBlack)
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
            return SearchViewController(viewModel: SearchViewModel())
            
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
