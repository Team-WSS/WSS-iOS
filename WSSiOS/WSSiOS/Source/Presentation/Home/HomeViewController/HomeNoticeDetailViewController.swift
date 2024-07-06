//
//  HomeNoticeDetailViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/6/24.
//

import UIKit

final class HomeNoticeDetailViewController: UIViewController {
    
    //MARK: - Properties

    
    //MARK: - UI Components
    
    private let rootView = HomeNoticeDetailView()
    private var backButton = UIButton()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.notice,
                                    left: self.backButton,
                                    right: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
        
        backButton.do {
            $0.setImage(.icNavigateLeft, for: .normal)
        }
    }
}
