//
//  SplashViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/31/25.
//

import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: - Components
    
    private let rootView = SplashView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
