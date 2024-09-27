//
//  WSSTabBarController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/6/24.
//

import UIKit

import Then

final class WSSTabBarController: UITabBarController {
    
    private let isLoggedIn: Bool
    
    init(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTabBarController()
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
        view.do {
            $0.backgroundColor = .wssWhite
        }
        
        tabBar.do {
            let border = CALayer()
            border.backgroundColor = UIColor.wssGray50.cgColor
            border.frame = CGRect(x: 0, y: 0, width: $0.frame.width, height: 1)
            
            $0.layer.addSublayer(border)
            $0.isTranslucent = false
            $0.itemPositioning = .centered
            $0.layer.masksToBounds = true
            $0.tintColor = .wssBlack
        }
    }
    
    //MARK: - Custom Method
    
    private func setTabBarController() {
        var navigationControllers = [UINavigationController]()
        
        for item in WSSTabBarItem.allCases {
            let viewController = item.itemViewController(isLoggedIn: isLoggedIn)
            let navigationController = createNavigationController(
                normalImage: item.normalItemImage,
                selectedImage: item.selectedItemImage,
                title: item.itemTitle,
                viewController: viewController
            )
            navigationControllers.append(navigationController)
        }
        
        setViewControllers(navigationControllers, animated: true)
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
