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
        setHierachy()
        setLayout()
    }
    
    //MARK: UI
    
    private func setUI() {
        tabBar.backgroundColor = .White
        tabBar.itemPositioning = .centered
    }
    
    //MARK: Hierachy
    
    private func setHierachy() {
        
    }
    
    //MARK: Layout
    
    private func setLayout() {
        
    }

}
