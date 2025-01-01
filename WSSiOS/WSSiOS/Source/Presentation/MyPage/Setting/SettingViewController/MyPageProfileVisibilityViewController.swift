//
//  MyPageProfileVisibilityViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 9/18/24.
//

import UIKit

import RxSwift

final class MyPageProfileVisibilityViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyPageProfileVisibilityViewModel
    private let disposeBag = DisposeBag()
    
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
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigation()
        hideTabBar()
        swipeBackGesture()
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = MyPageProfileVisibilityViewModel.Input(
            isVisibilityToggleButtonDidTap: rootView.profilePrivateToggleButton.rx.tap,
            backButtonDidTap: rootView.backButton.rx.tap,
            completeButtonDidTap: rootView.completeButton.rx.tap)
        
        let output = viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.changePrivateToggleButton
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, isPublic in
                owner.rootView.bindData(isPrivate: !isPublic)
            })
            .disposed(by: disposeBag)
        
        output.changeCompleteButton
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, change in
                owner.rootView.changeCompleteButton(change: change)
            })
            .disposed(by: disposeBag)
        
        output.popViewControllerAction
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UI

extension MyPageProfileVisibilityViewController {
    private func setNavigation() {
        setNavigationBar(title: StringLiterals.Navigation.Title.isVisibleProfile,
                         left: self.rootView.backButton,
                         right: self.rootView.completeButton)
    }
}
