//
//  MyPageChangeUserInfoViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 9/20/24.
//

import UIKit

import RxSwift

final class MyPageChangeUserInfoViewController: UIViewController {
     
    //MARK: - Properties
    
    private var viewModel: MyPageChangeUserInfoViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = MyPageChangeUserInfoView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageChangeUserInfoViewModel) {
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
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setNavigationBar()
        hideTabBar()
        swipeBackGesture()
    }
    
    //MARK: - Bind

    private func bindViewModel() {
        
    }
}

//MARK: - UI

extension MyPageChangeUserInfoViewController {
    private func setNavigationBar() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPageChangeUserInfo,
                                    left: self.rootView.backButton,
                                    right: self.rootView.completeButton)
    }
}

