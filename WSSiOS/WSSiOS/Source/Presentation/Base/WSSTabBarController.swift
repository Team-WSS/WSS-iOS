//
//  WSSTabBarController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/6/24.
//

import UIKit

import Then

final class WSSTabBarController: UITabBarController {
    
    //MARK: - UI Component
    
    let shadowView = UIView()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerTabBarController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabBarHeight: CGFloat = 49 + view.safeAreaInsets.bottom
        if UIScreen.isSE {
            tabBarHeight += 5
        }
        tabBar.frame.size.height = tabBarHeight
        tabBar.frame.origin.y = view.frame.height - tabBarHeight
        
        makeShadowRadius()
    }
    
    //MARK: - UI
    
    private func setUI() {
        tabBar.do {
            $0.backgroundColor = .White
            $0.itemPositioning = .centered
            $0.tintColor = .Black
            
            //탭바가 불투명해지는 현상을 막기 위해 false 처리 했지만 뒷배경이 없어 부자연스러워짐
//            $0.isTranslucent = false
        }
    }
    
    private func makeShadowRadius() {
        let layer = CAShapeLayer()
        let bezierPath = UIBezierPath(roundedRect: tabBar.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 24, height: 24))
        layer.path = bezierPath.cgPath
        tabBar.layer.mask = layer
        
        shadowView.do {
            $0.frame = tabBar.frame
            $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowRadius = 15
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowPath = bezierPath.cgPath
            $0.layer.masksToBounds = false
        }
        
        if let container = tabBar.superview {
            container.insertSubview(shadowView, belowSubview: tabBar)
        }
    }
    
    //MARK: - Custom TabBar
    
    private func registerTabBarController() {
        var naviControllers = [UINavigationController]()
        
        for item in WSSTabBarItem.allCases {
            let naviController = createNaviControllers(
                normalImage: item.normalItemImage,
                selectedImage: item.selectedItemImage,
                title: item.itemTitle,
                viewController: item.itemViewController
            )
            naviControllers.append(naviController)
        }
        setViewControllers(naviControllers, animated: true)
    }
    
    private func createNaviControllers(normalImage: UIImage,
                                       selectedImage: UIImage,
                                       title: String,
                                       viewController: UIViewController) -> UINavigationController {
        let naviController = UINavigationController(rootViewController: viewController)
        
        let item = UITabBarItem(
            title: title,
            image: normalImage,
            selectedImage: selectedImage
        )
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.Label2,
            .foregroundColor: UIColor.Gray200
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.Label2,
            .foregroundColor: UIColor.Black
        ]
        
        naviController.setNavigationBarHidden(true, animated: true)
        naviController.tabBarItem = item
        
        return naviController
    }
}
