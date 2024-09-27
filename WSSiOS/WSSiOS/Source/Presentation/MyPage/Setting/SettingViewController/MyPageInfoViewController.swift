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
    private let settingList = StringLiterals.MyPage.SettingInfo.allCases.map { $0.rawValue }
    private let emailRelay = BehaviorRelay(value: "")
    private let logoutRelay = PublishRelay<Bool>()
    private let updateDataRelay = BehaviorRelay<Bool>(value: false)
    private var genderAndBirthData = ChangeUserInfo(gender: "", birth: 0)
    
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
        bindCell()
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
    
    private func bindCell() {
        Observable.just(settingList)
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: MyPageSettingTableViewCell.cellIdentifier,
                cellType: MyPageSettingTableViewCell.self)) {(row, element, cell) in
                    cell.bindData(title: element)
                    if row == 1 {
                        cell.bindDescriptionData(title: self.emailRelay.value)
                    }
                }
                .disposed(by: disposeBag)
        
        rootView.tableView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                self.rootView.tableView.deselectRow(at: indexPath, animated: true)
                
                switch indexPath.row {
                case 0:
                    print("성별/나이 변경")
                    owner.pushToChangeUserInfoViewController(userInfo: owner.genderAndBirthData)
                case 1:
                    print("이메일")
                    break;
                case 2:
                    print("차단유저 목록")
                    owner.pushToBlockIDViewController()
                case 3:
                    print("로그아웃")
                    owner.presentToAlertViewController(iconImage: .icAlertWarningCircle,
                                                       titleText: StringLiterals.Alert.logoutTitle,
                                                       contentText: nil,
                                                       leftTitle: StringLiterals.Alert.cancel,
                                                       rightTitle: StringLiterals.Alert.logout,
                                                       rightBackgroundColor: UIColor.wssPrimary100.cgColor)
                    .subscribe(with: self, onNext: { owner, buttonType in
                        if buttonType == .right {
                            owner.logoutRelay.accept(true)
                        }
                    })
                    .disposed(by: owner.disposeBag)
                    
                case 4:
                    print("회원탈퇴")
                    owner.pushToMyPageDeleteIDWarningViewController()
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = MyPageInfoViewModel.Input(
            logoutButtonTapped: self.logoutRelay,
            backButtonDidTap: rootView.backButton.rx.tap,
            updateUserInfo: self.updateDataRelay)
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.popViewController
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
        
        output.genderAndBirth
            .bind(with: self, onNext: { owner, data in
                owner.genderAndBirthData = ChangeUserInfo(gender: data.gender, birth: data.birth)
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageInfoViewController: MyPageChangeUserInfoDelegate {    
    
    //MARK: - UI
    
    private func setNavigationBar() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPageInfo,
                                    left: self.rootView.backButton,
                                    right: nil)
    }
    
    //MARK: - Delegate
    
    private func pushToChangeUserInfoViewController(userInfo: ChangeUserInfo) {
        let viewController = MyPageChangeUserInfoViewController(
            viewModel: MyPageChangeUserInfoViewModel(
                userRepository: DefaultUserRepository(
                    userService: DefaultUserService(),
                    blocksService: DefaultBlocksService()),
                userInfo: userInfo)
        )
        
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func updateUserInfo() {
        self.updateDataRelay.accept(true)
        print("돌아와써")
    }
}

