//
//  OnboardingViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/27/24.
//

import UIKit

import RxSwift
import RxCocoa

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
        navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = nil
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = createViewModelInput()
        let output = viewModel.transform(from: input,
                                         disposeBag: disposeBag)
        bindViewModelOutput(output)
    }
    
    private func bindViewModelOutput(_ output: OnboardingViewModel.Output) {
        output.stageIndex
            .drive(with: self, onNext: { owner, stage in
                owner.rootView.progressView.updateProgressView(stage)
                owner.setNavigationBar(stage: stage)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            output.isNicknameTextFieldEditing.asObservable(),
            output.nicknameAvailablity.asObservable()
        )
        .observe(on: MainScheduler.instance)
        .bind(with: self, onNext: { owner, tuple in
            let (isEditing, availablity) = tuple
            owner.rootView.nickNameView.updateNicknameTextField(isEditing: isEditing,
                                                                availablity: availablity)
            owner.rootView.nickNameView.updateTextFieldInnerButton(isEditing: isEditing,
                                                                   availablity: availablity)
            owner.rootView.nickNameView.updateNickNameStatusDescriptionLabel(availablity: availablity)
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
        
        output.moveToNextStage
            .drive(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
                owner.scrollToNextItem()
            })
            .disposed(by: disposeBag)
        
        output.moveToHomeViewController
            .drive(with: self, onNext: { owner, _ in
                owner.onBoardingCompleted()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func createViewModelInput() -> OnboardingViewModel.Input {
        
        return OnboardingViewModel.Input(
            nicknameTextFieldEditingDidBegin: self.rootView.nickNameView.nicknameTextField.rx.controlEvent(.editingDidBegin),
            nicknameTextFieldEditingDidEnd: self.rootView.nickNameView.nicknameTextField.rx.controlEvent(.editingDidEnd),
            nicknameTextFieldText: self.rootView.nickNameView.nicknameTextField.rx.text.orEmpty.distinctUntilChanged(),
            duplicateCheckButtonDidTap: self.rootView.nickNameView.duplicateCheckButton.rx.tap,
            nextButtonDidTap: self.rootView.nickNameView.bottomButton.button.rx.tap
        )
    }
    
    //MARK: - Custom Method
    
    private func onBoardingCompleted() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.setRootToWSSTabBarController()
    }
    
    private func scrollToNextItem() {
        let currentOffset = rootView.scrollView.contentOffset
        let width = UIScreen.main.bounds.width
        let nextOffset = currentOffset.x + width
        
        rootView.scrollView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
    }
    
    private func setNavigationBar(stage: Int) {
        navigationItem.setHidesBackButton(stage == 0, animated: true)
        self.navigationItem.leftBarButtonItem = stage == 0 ? nil : UIBarButtonItem(customView: rootView.backButton)
    }
}
