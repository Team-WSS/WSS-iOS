//
//  MyPageInfoViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/17/24.
//

import UIKit

import RxSwift
import Then
import RxRelay

final class MyPageInfoViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageInfoViewModel
    private let settingList = StringLiterals.MyPage.SettingInfo.allCases.map { $0.rawValue }
    private let emailRelay = BehaviorRelay(value: "")
    
    //MARK: - UI Components
    
    private var rootView = MyPageSettingView()
    
    private let backButton = UIButton()
    
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
        
        swipeBackGesture()
        
        setUI()
        register()
        bindCell()
        bindViewModel()
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
    
    private func bindViewModel() {
        let input = MyPageInfoViewModel.Input()
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.email
            .subscribe(with: self, onNext: { owner, email in
                owner.emailRelay.accept(email)
            })
            .disposed(by: disposeBag)
        
        emailRelay
            .subscribe(onNext: { [weak self] _ in
                self?.rootView.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        self.backButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
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
