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
        let input = MyPageChangeUserInfoViewModel.Input(
            maleButtonTapped: rootView.genderMaleButton.rx.tap,
            femaleButtonTapped: rootView.genderFemaleButton.rx.tap,
            birthViewTapped: rootView.birthButtonView.rx.tapGesture(),
            completeButtonTapped: rootView.completeButton.rx.tap)
        
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
            .subscribe(with: self, onNext: { owner, _ in
                //VC 이동
            })
            .disposed(by: disposeBag)
        
        output.changeCompleteButton
            .subscribe(with: self, onNext: { owner, isEnabled in
                owner.rootView.isEnabledCompleteButton(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UI

extension MyPageChangeUserInfoViewController {
    private func setNavigationBar() {
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.myPageChangeUserInfo,
                                    left: self.rootView.backButton,
                                    right: self.rootView.completeButton)
    }
}

