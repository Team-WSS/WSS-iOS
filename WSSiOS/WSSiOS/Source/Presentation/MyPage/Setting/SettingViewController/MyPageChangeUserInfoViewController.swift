//
//  MyPageChangeUserInfoViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 9/20/24.
//

import UIKit

import RxSwift

final class MyPageChangeUserInfoViewController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel: MyPageChangeUserInfoViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = MyPageChangeUserInfoView()
    
    // MARK: - Life Cycle
    
    init(viewModel: MyPageChangeUserInfoViewModel) {
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
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setNavigationBar()
        hideTabBar()
        swipeBackGesture()
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let getNotificationUserBirth = NotificationCenter.default.rx.notification(NSNotification.Name("UserBirth"))
            .compactMap { notification -> Int? in
                return notification.userInfo?["userBirth"] as? Int
            }
        
        let input = MyPageChangeUserInfoViewModel.Input(
            maleButtonTapped: rootView.genderMaleButton.rx.tap,
            femaleButtonTapped: rootView.genderFemaleButton.rx.tap,
            birthViewTapped: rootView.birthButtonView.rx.tapGesture(),
            backButtonTapped: rootView.backButton.rx.tap,
            completeButtonTapped: rootView.completeButton.rx.tap,
            getNotificationUserBirth: getNotificationUserBirth)
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.dataBind
            .bind(with: self, onNext: { owner, data in
                owner.rootView.bindData(data: data)
            })
            .disposed(by: disposeBag)
        
        output.changeGender
            .subscribe(with: self, onNext: { owner, gender in
                owner.rootView.changeGenderButton(gender: gender)
            })
            .disposed(by: disposeBag)
        
        output.showBottomSheet
            .subscribe(with: self, onNext: { owner, birth in
                owner.presentModalViewController(MyPageChangeUserBirthViewController(userBirth: birth))
            })
            .disposed(by: disposeBag)
        
        output.changeCompleteButton
            .subscribe(with: self, onNext: { owner, isEnabled in
                owner.rootView.isEnabledCompleteButton(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.changeBirth
            .subscribe(with: self, onNext: { owner, birth in
                owner.rootView.changeBirthYearLabel(year: birth)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UI

extension MyPageChangeUserInfoViewController {
    private func setNavigationBar() {
        setWSSNavigationBar(title: StringLiterals.Navigation.Title.myPageChangeUserInfo,
                         left: self.rootView.backButton,
                         right: self.rootView.completeButton)
    }
}

