//
//  HomeViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/9/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    //MARK: - UI Components
    
    private let rootView = HomeView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .White
    }
}
