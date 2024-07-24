//
//  MyPageDeleteIDViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import RxSwift

final class MyPageDeleteIDViewController: UIViewController {
    
    //MARK: - Properties
    
    private let reasonCellTitle = StringLiterals.MyPage.DeleteIDReason.allCases.map { $0.rawValue }
    private let checkCellText = zip(StringLiterals.MyPage.DeleteIDCheckTitle.allCases, StringLiterals.MyPage.DeleteIDCheckContent.allCases).map { ($0.rawValue, $1.rawValue) }
    
    //MARK: - Components
    
    private let disposeBag = DisposeBag()
    private let rootView = MyPageDeleteIDView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        bindTableView()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setNavigationBar()
        hideTabBar()
    }
    
    private func register() {
        rootView.reasonTableView.register(
            MyPageDeleteIDReasonTableViewCell.self,
            forCellReuseIdentifier: MyPageDeleteIDReasonTableViewCell.cellIdentifier)
        
        rootView.checkTableView.register(
            MyPageDeleteIDCheckTableViewCell.self, forCellReuseIdentifier: MyPageDeleteIDCheckTableViewCell.cellIdentifier)
    }
    
    private func bindTableView() {
        Observable.just(reasonCellTitle)
            .bind(to: rootView.reasonTableView.rx.items(
                cellIdentifier: MyPageDeleteIDReasonTableViewCell.cellIdentifier,
                cellType: MyPageDeleteIDReasonTableViewCell.self)) { row, element, cell in
                    cell.bindData(text: element)
                }
                .disposed(by: disposeBag)
        
        Observable.just(checkCellText)
            .bind(to: rootView.checkTableView.rx.items(
                cellIdentifier: MyPageDeleteIDCheckTableViewCell.cellIdentifier,
                cellType: MyPageDeleteIDCheckTableViewCell.self)) { row, element, cell in
                    cell.bindData(title: element.0, description: element.1)
                }
                .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        rootView.backButton.rx.tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
    }
}

//MARK: - UI

extension MyPageDeleteIDViewController {
    private func setNavigationBar() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.deleteID,
                                    left: self.rootView.backButton,
                                    right: nil)
    }
}

