//
//  MyPageChangeUserBirthViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 9/23/24.
//

import UIKit

import RxSwift

final class MyPageChangeUserBirthViewController: UIViewController {
    
    //MARK: - Properties
    
    private let userBirth: Int
    
    private let birthRange = Observable.just(Array(1900...2024))
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = MyPageChangeUserBirthView()
    
    // MARK: - Life Cycle
    
    init(userBirth: Int) {
        self.userBirth = userBirth
        
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
    }
    
    private func register() {
        rootView.tableView.register(MyPageChangeUserBirthTableViewCell.self,
                                    forCellReuseIdentifier: MyPageChangeUserBirthTableViewCell.cellIdentifier)
    }
    //MARK: - Bind
    
    private func bindAction() {
        rootView.cancelButton.rx.tap 
            .bind(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        rootView.completeButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                //로직 추가
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        self.birthRange
            .bind(to: rootView.tableView.rx.items(
                cellIdentifier: MyPageChangeUserBirthTableViewCell.cellIdentifier,
                cellType: MyPageChangeUserBirthTableViewCell.self)) { row, year, cell in
                    cell.bindYear(year: year)
                }
                .disposed(by: disposeBag)
    }
}
