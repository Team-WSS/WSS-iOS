//
//  MyPageInfoViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import UIKit

import RxSwift
import Then

final class MyPageInfoViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let settingList = StringLiterals.MyPage.SettingInfo.allCases.map { $0.rawValue }
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPageInfo,
                                    left: backButton,
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
                    if row == 1 {
                        cell.bindDescriptionData(title: element)
                    }
                }
                .disposed(by: disposeBag)
        
        rootView.tableView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                self.rootView.tableView.deselectRow(at: indexPath, animated: true)

                switch indexPath.row {
                case 0:
                    print("성별/나이 변경")
                    //pushVC
                case 1:
                    print("이메일")
                    //pushVC
                case 2:
                    print("차단유저 목록")
                    //pushVC
                case 3:
                    print("로그아웃")
                    //pushModalVC
                case 4:
                    print("회원탈퇴")
                    //pushVC
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageInfoViewController {
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft, for: .normal)
        }
    }
}
