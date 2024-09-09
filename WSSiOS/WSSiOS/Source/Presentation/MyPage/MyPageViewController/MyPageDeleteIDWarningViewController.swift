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
    
    private let dummy = UserNovelStatusResult(interestNovelCount: 1, watchingNovelCount: 100, watchedNovelCount: 333, quitNovelCount: 29)
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = MyPageDeleteIDWarningView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.bindData(count: dummy)
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        setNavigationBar()
        hideTabBar()
        swipeBackGesture()
    }

    //MARK: - Bind
    
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