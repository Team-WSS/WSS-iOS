//
//  MyPageInfoViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import UIKit

import RxSwift
import RxRelay

final class MyPageInfoViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageInfoViewModel
    private let emailRelay = BehaviorRelay(value: "")
    private let logoutRelay = PublishRelay<Bool>()
    
    //MARK: - UI Components
    
    private var rootView = MyPageSettingView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageInfoViewModel) {
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
        
        setNavigationBar()
        hideTabBar()
        swipeBackGesture()
    }
    
    //MARK: - Delegate
    
    private func register() {
        rootView.tableView.register(
            MyPageSettingTableViewCell.self,
            forCellReuseIdentifier: MyPageSettingTableViewCell.cellIdentifier)
    }
    
    
    //MARK: - Bind

    private func bindViewModel() {
        let input = MyPageInfoViewModel.Input(
            cellDidTapped: self.rootView.tableView.rx.itemSelected,
            logoutButtonTapped: self.logoutRelay,
            backButtonDidTap: rootView.backButton.rx.tap,
            changeInfoNotification: NotificationCenter.default.rx.notification(NSNotification.Name("ChangeUserInfo")).asObservable())
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.bindSettingCell
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: MyPageSettingTableViewCell.cellIdentifier,
                cellType: MyPageSettingTableViewCell.self)) {(row, element, cell) in
                    cell.bindData(title: element)
                    if row == 1 {
                        cell.bindDescriptionData(title: self.emailRelay.value)
                    }
                }
                .disposed(by: disposeBag)
        
        output.pushToChangeUserInfoViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, data in
                owner.pushToChangeUserInfoViewController()
            })
            .disposed(by: disposeBag)
        
        output.pushToBlockIDViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.pushToBlockIDViewController()
            })
            .disposed(by: disposeBag)
        
        output.pushToMyPageDeleteIDWarningViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.pushToMyPageDeleteIDWarningViewController()
            })
            .disposed(by: disposeBag)
        
        output.presentToAlertViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self as MyPageInfoViewController, onNext: { owner, _ in
                owner.presentToAlertViewController(iconImage: .icModalWarning,
                                                   titleText: StringLiterals.Alert.logoutTitle,
                                                   contentText: nil,
                                                   leftTitle: StringLiterals.Alert.cancel,
                                                   rightTitle: StringLiterals.Alert.logout,
                                                   rightBackgroundColor: UIColor.wssPrimary100.cgColor)
                .bind(with: self, onNext: { owner, buttonType in
                    if buttonType == .right {
                        owner.logoutRelay.accept(true)
                    }
                })
                .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
        output.pushToLoginViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.pushToLoginViewController()
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.bindEmail
            .bind(with: self, onNext: { owner, email in
                owner.emailRelay.accept(email)
                owner.rootView.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.showToastMessage
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.showToast(.changeUserInfo)
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageInfoViewController {
    
    //MARK: - UI
    
    private func setNavigationBar() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPageInfo,
                                    left: self.rootView.backButton,
                                    right: nil)
    }
}

