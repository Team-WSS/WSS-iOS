//
//  MyPageInfoViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import UIKit

import RxSwift
import RxCocoa

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
        bindAction()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindViewWillAppearAction()
    }
    
    //MARK: - Delegate
    
    private func register() {
        rootView.settingTableView.register( MyPageSettingTableViewCell.self,
                                            forCellReuseIdentifier: MyPageSettingTableViewCell.cellIdentifier)
    }
    
    
    //MARK: - Bind
    
    private func bindViewWillAppearAction() {
        hideTabBar()
        swipeBackGesture()
        setWSSNavigationBar(title: StringLiterals.Navigation.Title.myPageInfo,
                            left: self.rootView.backButton,
                            right: nil)
    }
    
    private func bindAction() {
        rootView.backButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NSNotification.Name("ChangeUserInfo"))
            .bind(with: self, onNext: { owner, _ in
                owner.showToast(.changeUserInfo)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = MyPageInfoViewModel.Input(
            cellDidTapped: self.rootView.settingTableView.rx.itemSelected,
            logoutButtonTapped: self.logoutRelay)
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.cellData
            .bind(to: rootView.settingTableView.rx.items(
                cellIdentifier: MyPageSettingTableViewCell.cellIdentifier,
                cellType: MyPageSettingTableViewCell.self)) {(row, element, cell) in
                    cell.bindData(title: element)
                    if row == 1 {
                        cell.bindDescriptionData(title: self.emailRelay.value)
                    }
                }
                .disposed(by: disposeBag)
        
        output.emailData
            .bind(with: self, onNext: { owner, email in
                owner.emailRelay.accept(email)
                owner.rootView.settingTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.pushToOtherViewController
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, destination in
                switch destination {
                case .changeUserInfo:
                    owner.pushToChangeUserInfoViewController()
                case .blockUser:
                    owner.pushToBlockUserViewController()
                case .myPageDeleteIDWarning:
                    owner.pushToMyPageDeleteIDWarningViewController()
                case .logoutAlert:
                    owner.presentToAlertViewController(iconImage: .icModalWarning,
                                                       titleText: StringLiterals.Alert.logoutTitle,
                                                       contentText: nil,
                                                       leftTitle: StringLiterals.Alert.cancel,
                                                       rightTitle: StringLiterals.Alert.logout,
                                                       rightBackgroundColor: UIColor.wssPrimary100.cgColor)
                    .bind(with: self, onNext: { owner, buttonType in
                        if buttonType == .right {
                            owner.logoutRelay.accept(true)
                            AmplitudeManager.shared.track(AmplitudeEvent.MyPage.logout)
                        }
                    })
                    .disposed(by: owner.disposeBag)
                case .login:
                    owner.pushToLoginViewController()
                }
            })
            .disposed(by: disposeBag)
    }
}
