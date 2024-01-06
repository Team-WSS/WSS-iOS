//
//  WSSTabBarController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/6/24.
//

import UIKit

class WSSTabBarController: UITabBarController {
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerTabBarController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tabBarHeight: CGFloat = 71
        tabBar.frame.size.height = tabBarHeight
        tabBar.frame.origin.y = view.frame.height - tabBarHeight
        
        makeRadius()
    }
    
    //MARK: UI
    
    private func setUI() {
        tabBar.backgroundColor = .White
        tabBar.itemPositioning = .centered
    }
    
    private func makeRadius() {
        let layer = CAShapeLayer()
        let bezierPath = UIBezierPath(roundedRect: tabBar.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 24, height: 24))
        layer.path = bezierPath.cgPath
        tabBar.layer.mask = layer
    }
    
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
        
        naviController.setNavigationBarHidden(true, animated: true)
        naviController.tabBarItem = item
        
        return naviController
    }
}
