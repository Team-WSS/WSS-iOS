//
//  MyPageBlockUserViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/29/24.
//

import UIKit

import RxSwift
import RxRelay

final class MyPageBlockUserViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageBlockUserViewModel
    private let unblockButtonTapRelay = PublishRelay<IndexPath>()
    
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
        
        delegate()
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
    
    private func delegate() {
        rootView.blockTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func register() {
        rootView.blockTableView.register(
            MyPageBlockUserTableViewCell.self,
            forCellReuseIdentifier: MyPageBlockUserTableViewCell.cellIdentifier)
    }
    
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = MyPageBlockUserViewModel.Input(
            backButtonDidTap: rootView.backButton.rx.tap,
            unblockButtonDidTap: self.rootView.blockTableView.rx.itemSelected.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.bindCell
            .bind(to: rootView.blockTableView.rx.items(cellIdentifier: MyPageBlockUserTableViewCell.cellIdentifier,cellType: MyPageBlockUserTableViewCell.self)) { row, data, cell in
                cell.bindData(image: data.avatarImage, nickname: data.nickname)
            }
            .disposed(by: disposeBag)
        
        output.showEmptyView
            .drive(with: self, onNext: { owner, isShown in
                owner.rootView.emptyView.isHidden = !isShown
            })
            .disposed(by: disposeBag)
        
        output.toastMessage
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, nickname in
                owner.showToast(.deleteBlockUser(nickname: nickname))
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.reloadTableView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.blockTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setNavigation() {
        setNavigationBar(title: StringLiterals.Navigation.Title.myPageBlockUser,
                         left: self.rootView.backButton,
                         right: nil)
    }
}
