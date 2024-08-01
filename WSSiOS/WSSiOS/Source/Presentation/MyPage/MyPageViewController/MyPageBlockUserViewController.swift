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
    private let viewModel: MyPageBlockUserViewModel
    
    //MARK: - UI Components
    
    private var rootView = MyPageBlockUserView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageBlockUserViewModel) {
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
        
        register()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        swipeBackGesture()
        setNavigation()
        hideTabBar()
    }
    
    //MARK: - Delegate
    
    private func register() {
        rootView.blockTableView.register(
            MyPageBlockUserTableViewCell.self,
            forCellReuseIdentifier: MyPageBlockUserTableViewCell.cellIdentifier)
    }
    
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = MyPageBlockUserViewModel.Input(
            backButtonDidTap: rootView.backButton.rx.tap
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
     
        output.bindCell
            .bind(to: rootView.blockTableView.rx.items(cellIdentifier: MyPageBlockUserTableViewCell.cellIdentifier, cellType: MyPageBlockUserTableViewCell.self)) { row, data, cell in
                cell.bindData(image: .avaterExample, nickname: data.nickname)
            }
            .disposed(by: disposeBag)
    }
    
    private func setNavigation() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPageBlockUser,
                                    left: self.rootView.backButton,
                                    right: nil)
    }
}
