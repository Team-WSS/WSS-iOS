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
        
        tabBar.frame.size.height = 71
    }
    
    //MARK: UI
    
    private func setUI() {
        tabBar.backgroundColor = .White
        tabBar.itemPositioning = .centered
        
        let layer = CAShapeLayer()
        let bezierPath = UIBezierPath(roundedRect: tabBar.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4))
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
