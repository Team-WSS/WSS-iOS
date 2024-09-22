//
//  MyPageDeleteIDWarningViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import RxSwift

final class MyPageDeleteIDWarningViewController: UIViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepository
    
    //MARK: - Components
    
    private let rootView = MyPageDeleteIDWarningView()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        
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
        
        bindData()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setNavigationBar()
        hideTabBar()
        swipeBackGesture()
    }
    
    //MARK: - Bind
    
    private func bindData() {
        userRepository.getUserNovelStatus()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, status in 
                owner.rootView.bindData(count: status)
            },onError: { owner, error in
                print(error)
            })
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
        
        rootView.completeButton.rx.tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(with: self, onNext: { owner, _ in
                owner.pushToMyPageDeleteIDViewController()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UI

extension MyPageDeleteIDWarningViewController {
    private func setNavigationBar() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.deleteID,
                                    left: self.rootView.backButton,
                                    right: nil)
    }
}
