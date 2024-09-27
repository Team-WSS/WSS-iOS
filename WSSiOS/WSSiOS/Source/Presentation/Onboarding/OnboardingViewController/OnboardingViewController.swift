//
//  OnboardingViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/27/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class OnboardingViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: OnboardingViewModel
    let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = OnboardingView()
    
    //MARK: - Life Cycle
    
    init(viewModel: OnboardingViewModel) {
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
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - UI
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .wssWhite
        navigationItem.title = ""
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = createViewModelInput()
        let output = viewModel.transform(from: input,
                                         disposeBag: disposeBag)
        bindViewModelOutput(output)
    }
    
    private func bindViewModelOutput(_ output: OnboardingViewModel.Output) {
        Observable.combineLatest(
            output.isNicknameTextFieldEditing.asObservable(),
            output.isNicknameAvailable.asObservable()
        )
        .observe(on: MainScheduler.instance)
        .bind(with: self, onNext: { owner, tuple in
            let (isEditing, isAvailable) = tuple
            owner.rootView.nickNameView.updatenickNameTextField(isEditing: isEditing,
                                                                isAvailable: isAvailable)
            owner.rootView.nickNameView.updateTextFieldInnerButton(isEditing: isEditing,
                                                                   isAvailable: isAvailable)
        })
        .disposed(by: disposeBag)
        
        output.isDuplicateCheckButtonEnabled
            .drive(with: self, onNext: { owner, isEnabled in
                owner.rootView.nickNameView.updateDuplicateCheckButton(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
        
        output.isNextButtonAvailable
            .drive(with: self, onNext: { owner, isEnabled in
                owner.rootView.nickNameView.bottomButton.updateButtonEnabled(isEnabled)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func createViewModelInput() -> OnboardingViewModel.Input {
        
        return OnboardingViewModel.Input(
            nicknameTextFieldEditingDidBegin: self.rootView.nickNameView.nicknameTextField.rx.controlEvent(.editingDidBegin),
            nicknameTextFieldEditingDidEnd: self.rootView.nickNameView.nicknameTextField.rx.controlEvent(.editingDidEnd),
            nicknameTextFieldText: self.rootView.nickNameView.nicknameTextField.rx.text.orEmpty.distinctUntilChanged()
        )
    }
}
