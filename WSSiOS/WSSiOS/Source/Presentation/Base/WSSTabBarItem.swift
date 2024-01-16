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
            return ImageLiterals.icon.Tabbar.home
        case .library:
            return ImageLiterals.icon.Tabbar.library
        case .record:
            return ImageLiterals.icon.Tabbar.record
        case .myPage:
            return ImageLiterals.icon.Tabbar.myPage
        default:
            return UIImage()
        }
    }
    
    var selectedItemImage: UIImage {
        switch self {
        case .home: 
            return ImageLiterals.icon.Tabbar.homeSelected
        case .library:
            return ImageLiterals.icon.Tabbar.librarySelected
        case .record:
            return ImageLiterals.icon.Tabbar.recordSelected
        case .myPage:
            return ImageLiterals.icon.Tabbar.myPageSelected
        default:
            return UIImage()
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
        default:
            return String()
        }
    }
    
    var itemViewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController(userRepository: DefaultUserRepository(userService: DefaultUserService()))
        case .library:
            return LibraryViewController()
        case .record:
            return RecordViewController()
        case .myPage:
            return MyPageViewController()
        default:
            return UIViewController()
        }
    }
}
