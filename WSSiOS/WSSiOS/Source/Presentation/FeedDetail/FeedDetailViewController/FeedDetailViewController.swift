//
//  FeedDetailViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit


final class FeedDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    private var backButton = UIButton()
    private var dotsButton = UIButton()
    
    //MARK: - UI Components
    
    private let rootView = FeedDetailView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        preparationSetNavigationBar(title: StringLiterals.FeedDetail.title,
                                    left: self.backButton,
                                    right: self.dotsButton)
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
        
        dotsButton.do {
            $0.setImage(.icThreedots, for: .normal)
        }
    }
    
    //MARK: - Bind
    
}
