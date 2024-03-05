//
//  WSSTabBarItem.swift
//  WSSiOS
//
//  Created by 신지원 on 1/7/24.
//

import UIKit

enum WSSTabBarItem: CaseIterable {
    
    case home, library, record, myPage
    
    var normalItemImage: UIImage {
        switch self {
        case .home:
            return .icNavigateHome
        case .library:
            return .icNavigateLibrary
        case .record:
            return .icNavigateRecord
        case .myPage:
            return .icNavigateMy
        }
    }
    
    var selectedItemImage: UIImage {
        switch self {
        case .home:
            return .icNavigateHomeSelected
        case .library:
            return .icNavigateLibrarySelected
        case .record:
            return .icNavigateRecordSelected
        case .myPage:
            return .icNavigateMySelected
        }
    }
    
    var itemTitle: String {
        switch self {
        case .home:
            return StringLiterals.Tabbar.Title.home
        case .library:
            return StringLiterals.Tabbar.Title.library
        case .record:
            return StringLiterals.Tabbar.Title.record
        case .myPage:
            return StringLiterals.Tabbar.Title.myPage
        }
    }
    
    var itemViewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController(
                userRepository: DefaultUserRepository(
                    userService: DefaultUserService()
                ),
                recommendRepository: DefaultRecommendRepository(
                    recommendService: DefaultRecommendService()
                )
            )
            
        case .library:
            return LibraryViewController(
                userNovelListRepository: DefaultUserNovelRepository(
                    userNovelService: DefaultUserNovelService()
                )
            )
            
        case .record:
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
