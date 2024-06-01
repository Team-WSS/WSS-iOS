//
//  MyPageChangeNicknameViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/12/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class MyPageChangeNicknameViewController: UIViewController {
    
    //MARK: - Properties
    
    private let userNickName : String
    private lazy var newNickName = ""
    
    //MARK: - Components
    
    private let rootView = MyPageChangeNicknameView()
    private lazy var backButton = UIButton()
    private lazy var completeButton = UIButton()
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageChangeNickNameViewModel
    
    // MARK: - Life Cycle
    
    init(userNickName: String, viewModel: MyPageChangeNickNameViewModel) {
        self.userNickName = userNickName
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
        
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.changeNickname,
                                    left: self.backButton,
                                    right: self.completeButton)
        hideTabBar()
        setUI()
        bindViewModel()
        swipeBackGesture()
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        rootView.changeNicknameTextField.text = userNickName
        
        let input = MyPageChangeNickNameViewModel.Input(
            updateNicknameTextField: rootView.changeNicknameTextField.rx.text.orEmpty.asDriver(),
            completeButtonDidTap: completeButton.rx.tap,
            clearButtonDidTap: rootView.setClearButton.rx.tap
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        output.textFieldUnderlineColor
            .subscribe(with: self, onNext: { owner, isAble in
                let color = isAble ? UIColor.wssPrimary100 : UIColor.wssGray200
                owner.rootView.textFieldUnderBarView.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        output.countLabelText
            .subscribe(with: self, onNext: { owner, text in
                owner.rootView.countNicknameLabel.text = text
            })
            .disposed(by: disposeBag)
        
        output.completeButtonTitleColor
            .subscribe(with: self, onNext: { owner, isAble in
                let color = isAble ? UIColor.wssPrimary100 : UIColor.wssGray200
                owner.completeButton.setTitleColor(color, for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.newNicknameText
            .subscribe(with: self, onNext: { owner, nickname in
                owner.rootView.changeNicknameTextField.text = nickname
            })
            .disposed(by: disposeBag)
        
        output.completeButtonAction
            .subscribe(with: self, onNext: { owner, isAble in
                if isAble {
                    owner.popToLastViewController()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageChangeNicknameViewController {
    
    //MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        completeButton.do {
            $0.setTitle(StringLiterals.MyPage.ChangeNickname.complete, for: .normal)
            $0.setTitleColor(.wssPrimary100, for: .normal)
            $0.titleLabel?.font = .Title2
        }
    }
}
