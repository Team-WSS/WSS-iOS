//
//  MyPageProfileEditViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import UIKit

import RxSwift

final class MyPageEditProfileViewController: UIViewController {

    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel = 
    
    //MARK: - Components
    
    private let rootView = MyPageEditProfileView()
    
    // MARK: - Life Cycle
    
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
    
    private func bindViewModel() {
        
    }
}

//MARK: - UI

extension MyPageEditProfileViewController {
    private func setNavigation() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPageInfo,
                                    left: self.rootView.backButton,
                                    right: self.rootView.completeButton)
    }
}

