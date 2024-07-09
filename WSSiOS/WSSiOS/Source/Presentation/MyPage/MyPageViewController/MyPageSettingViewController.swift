//
//  MyPageSettingViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/10/24.
//

import UIKit

import RxSwift

final class MyPageSettingViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let settingList = StringLiterals.MyPage.Setting.allCases.map { $0.rawValue }
    
    //MARK: - UI Components
    
    private var rootView = MyPageSettingView()
    
    private let backButton = UIButton()
    
    // MARK: - Life Cycle

    override func loadView() {
        self.view = rootView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeBackGesture()
        
        setUI()
        register()
        bindCell()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPageSetting,
                                    left: self.backButton,
                                    right: nil)
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
        rootView.tableView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                self.rootView.tableView.deselectRow(at: indexPath, animated: true)

                switch indexPath.row {
                case 0:
                    print("계정정보")
                    owner.pushToMyPageInfoViewController()
                case 1:
                    print("프로필 공개 여부 설정")
                    //pushVC
                case 2:
                    print("웹소소 공식 계정")
                    if let url = URL(string: StringLiterals.MyPage.SettingURL.instaURL) {
                        UIApplication.shared.open(url, options: [:])
                    }
                case 3:
                    print("문의하기 & 의견 보내기")
                    if let url = URL(string: "https://www.instagram.com/2s.ena/") {
                        UIApplication.shared.open(url, options: [:])
                    }
                case 4:
                    print("앱 평점 남기기")
                    if let url = URL(string: "https://www.instagram.com/2s.ena/") {
                        UIApplication.shared.open(url, options: [:])
                    }
                case 5:
                    print("서비스 이용약관")
                    if let url = URL(string: StringLiterals.MyPage.SettingURL.termsURL) {
                        UIApplication.shared.open(url, options: [:])
                    }
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Action
    
    private func bindAction() {
        backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageSettingViewController {
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft, for: .normal)
        }
    }
}
