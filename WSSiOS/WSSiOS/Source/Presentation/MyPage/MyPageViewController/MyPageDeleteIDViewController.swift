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
    
    //MARK: - Components
    
    private let disposeBag = DisposeBag()
    private let rootView = MyPageDeleteIDView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        setNavigationBar()
        hideTabBar()
    }
    
    private func setNavigationBar() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.deleteID,
                                    left: self.rootView.backButton,
                                    right: nil)
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

