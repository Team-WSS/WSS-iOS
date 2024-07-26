//
//  MyPageProfileEditViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import UIKit

import RxSwift

final class MyPageEditProfileViewController: UIViewController {

    //MARK: - Components
    
    private let disposeBag = DisposeBag()
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
}

//MARK: - UI

extension MyPageEditProfileViewController {
    private func setNavigation() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPageInfo,
                                    left: self.backButton,
                                    right: nil)
    }
}

