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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBar.frame.size.height = 71
    }
    
    //MARK: UI
    
    private func setUI() {
        tabBar.backgroundColor = .White
        tabBar.itemPositioning = .centered
    }
    
}
