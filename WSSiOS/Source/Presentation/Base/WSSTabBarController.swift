//
//  WSSTabBarController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/6/24.
//

import UIKit

import Then
import RxSwift
import RxCocoa

final class WSSTabBarController: UITabBarController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let isLogined = APIConstants.isLogined
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var tabBarHeight: CGFloat = 49 + view.safeAreaInsets.bottom
        if UIScreen.isSE {
            tabBarHeight += 5
        }
        tabBar.frame.size.height = tabBarHeight
        tabBar.frame.origin.y = view.frame.height - tabBarHeight
    }
    
    //MARK: - UI
    
    private func setUI() {
        tabBar.itemPositioning = .centered
        
        if #available(iOS 26.0, *) {
            tabBar.isTranslucent = true
            tabBar.tintColor = .wssBlack
            tabBar.unselectedItemTintColor = .wssGray200
        } else {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            appearance.backgroundColor = .wssWhite
            appearance.shadowColor = .clear
            
            appearance.stackedLayoutAppearance.normal.iconColor = .wssGray200
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.wssGray200
            ]
            
            appearance.stackedLayoutAppearance.selected.iconColor = .wssBlack
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.wssBlack
            ]
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
            
            tabBar.isTranslucent = false
        }
    }
    
    //MARK: - Custom Method
    
    private func bind() {
        if isLogined {
            DefaultUserInfoRepository(userService: DefaultUserService()).getUserMeData()
                .observe(on: MainScheduler.instance)
                .subscribe(with: self, onNext: { owner, data in
                    UserDefaults.standard.setValue(data.userId, forKey: StringLiterals.UserDefault.userId)
                    UserDefaults.standard.setValue(data.nickname, forKey: StringLiterals.UserDefault.userNickname)
                    UserDefaults.standard.setValue(data.gender, forKey: StringLiterals.UserDefault.userGender)
                    
                    owner.setTabBarController()
                })
                .disposed(by: disposeBag)
        } else {
            self.setTabBarController()
        }
        
        NotificationCenter.default.rx.notification(NotificationName.moveToLibraryTab)
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, notification in
                owner.selectedIndex = WSSTabBarItem.library.rawValue
            })
            .disposed(by: disposeBag)
    }
    
    private func setTabBarController() {
        var navigationControllers = [UINavigationController]()
        
        for item in WSSTabBarItem.allCases {
            let viewController = item.itemViewController()
            let navigationController = createNavigationController(
                normalImage: item.normalItemImage,
                selectedImage: item.selectedItemImage,
                title: item.itemTitle,
                viewController: viewController
            )
            navigationControllers.append(navigationController)
        }
        
        setViewControllers(navigationControllers, animated: false)
    }
    
    private func createNavigationController(normalImage: UIImage,
                                            selectedImage: UIImage,
                                            title: String,
                                            viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let item = UITabBarItem(
            title: title,
            image: normalImage,
            selectedImage: selectedImage
        )
        
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.tabBarItem = item
        
        return navigationController
    }
}

extension WSSTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let selectedIndex = viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        if !isLogined && (selectedIndex >= WSSTabBarItem.feed.rawValue) {
            self.presentInduceLoginViewController()
            return false
        }
        
        if tabBarController.selectedViewController === viewController {
            if let navigationController = viewController as? UINavigationController,
               let rootVC = navigationController.viewControllers.first {
                
                switch rootVC {
                case let homeVC as HomeViewController:
                    homeVC.scrollToTop()
                    
                case let feedVC as FeedViewController:
                    feedVC.scrollToTop()
                    
                case let myPageVC as MyPageViewController:
                    myPageVC.scrollToTop()
                    
                default:
                    break
                }
            }
            return false
        }
        
        viewController.view.alpha = 0
        viewController.view.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
        
        UIView.transition(with: tabBarController.view,
                          duration: 0.2,
                          options: [.transitionCrossDissolve, .curveEaseOut],
                          animations: {
            viewController.view.alpha = 1
        })
        
        return true
    }
}
