//
//  MyPageSettingViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/10/24.
//

import UIKit

import RxSwift
import RxRelay

final class MyPageSettingViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let settingList = StringLiterals.MyPage.Setting.allCases.map { $0.rawValue }
    private let changeVisibilityNotification = PublishRelay<Bool>()
    
    //MARK: - UI Components
    
    private var rootView = MyPageSettingView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        bindCell()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
        swipeBackGesture()
        hideTabBar()
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
                }
                .disposed(by: disposeBag)
    }
    
    //MARK: - Action
    
    private func bindAction() {
        self.rootView.backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                self.rootView.tableView.deselectRow(at: indexPath, animated: true)
                
                switch indexPath.row {
                case 0:
                    print("계정정보")
                    owner.pushToMyPageInfoViewController()
                case 1:
                    print("프로필 공개 여부 설정")
                    owner.pushToMyPageProfileVisibilityViewController()
                case 2:
                    print("웹소소 공식 계정")
                    if let url = URL(string: StringLiterals.MyPage.SettingURL.instaURL) {
                        UIApplication.shared.open(url, options: [:])
                    }
                case 3:
                    print("문의하기 & 의견 보내기")
                    if let url = URL(string: StringLiterals.MyPage.SettingURL.QNAInHompageURL) {
                        UIApplication.shared.open(url, options: [:])
                    }
                case 4:
                    print("개인정보 처리 방침")
                    if let url = URL(string: StringLiterals.MyPage.SettingURL.termsURL) {
                        UIApplication.shared.open(url, options: [:])
                    }
                case 5:
                    print("서비스 이용약관")
                    if let url = URL(string: StringLiterals.MyPage.SettingURL.infoURL) {
                        UIApplication.shared.open(url, options: [:])
                    }
                default: break
                }
            })
            .disposed(by: disposeBag)
        
        changeVisibilityNotification
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, status in
                owner.showToast(status ? .changePublic : .changePrivate)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NSNotification.Name("ChangeVisibility"))
            .compactMap { notification -> Bool? in
                notification.object as? Bool
            }
            .bind(to: changeVisibilityNotification)
            .disposed(by: disposeBag)
    }
}

//MARK: - UI

extension MyPageSettingViewController {
    private func setNavigationBar() {
        setNavigationBar(title: StringLiterals.Navigation.Title.myPageSetting,
                         left: self.rootView.backButton,
                         right: nil)
    }
}
