//
//  MyPageBlockUserViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/29/24.
//

import UIKit

import RxSwift

final class MyPageBlockUserViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private var rootView = MyPageBlockUserView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        swipeBackGesture()
        setNavigation()
        hideTabBar()
    }
    
    //MARK: - Delegate
    
    private func register() {
        rootView.tableView.register(
            MyPageSettingTableViewCell.self,
            forCellReuseIdentifier: MyPageSettingTableViewCell.cellIdentifier)
    }
    
    
    //MARK: - Bind
    
    private func setNavigation() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPageBlockUser,
                                    left: self.rootView.backButton,
                                    right: nil)
    }
}
