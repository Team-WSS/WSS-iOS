//
//  MyPageProfileVisibilityViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 9/18/24.
//

import UIKit

final class MyPageProfileVisibilityViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyPageProfileVisibilityViewModel
    
    //MARK: - Components
    
    private let rootView = MyPageProfileVisibilityView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageProfileVisibilityViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigation()
        hideTabBar()
        swipeBackGesture()
    }
    
    //MARK: - Bind
    
    
}

//MARK: - UI

extension MyPageProfileVisibilityViewController {
    private func setNavigation() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.isVisibleProfile,
                                    left: self.rootView.backButton,
                                    right: self.rootView.completeButton)
    }
}
