//
//  OnboardingViewController.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/27/24.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class OnboardingViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: OnboardingViewModel
    let disposeBag = DisposeBag()
    let selectedBirth = BehaviorSubject<Int?>(value: nil)
    
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
        
        rootView.nickNameView.nicknameTextField.delegate = self
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
        self.setWSSNavigationBar(title: nil, left: nil, right: nil)
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
        // Nickname
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
        
        output.nicknameTextFieldClear
            .drive(with: self, onNext: { owner, _ in
                owner.rootView.nickNameView.nicknameTextField.text = ""
            })
            .disposed(by: disposeBag)
        
        output.isDuplicateCheckButtonEnabled
            .drive(with: self, onNext: { owner, isEnabled in
                owner.rootView.nickNameView.updateDuplicateCheckButton(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
        
        output.isNicknameNextButtonEnabled
            .drive(with: self, onNext: { owner, isEnabled in
                owner.rootView.nickNameView.bottomButton.updateButtonEnabled(isEnabled)
            })
            .disposed(by: disposeBag)
        
        // BirthGender
        output.selectedGender
            .drive(with: self, onNext: { owner, selectedGender in
                if let selectedGender {
                    owner.rootView.birthGenderView.updateGenderButton(selectedGender: selectedGender)
                }
            })
            .disposed(by: disposeBag)
        
        output.showBirthPickerModal
            .withLatestFrom(output.selectedBirth)
            .drive(with: self, onNext: { owner, value in
                owner.presentModalViewController(BirthPickerViewController(birth: value ?? 2000))
            })
            .disposed(by: disposeBag)
        
        output.selectedBirth
            .drive(with: self, onNext: { owner, value in
                owner.rootView.birthGenderView.updateBirthLabel(selectedBirth: value)
            })
            .disposed(by: disposeBag)
        
        output.isBirthGenderNextButtonEnabled
            .drive(with: self, onNext: { owner, isEnabled in
                owner.rootView.birthGenderView.bottomButton.updateButtonEnabled(isEnabled)
            })
            .disposed(by: disposeBag)
        
        // GenrePreference
        output.selectedGenres
            .drive(with: self, onNext: { owner, selectedGenres in
                owner.rootView.genrePreferenceView.updateGenreButtons(selectedGenres: selectedGenres)
            })
            .disposed(by: disposeBag)
        
        output.isGenrePreferenceNextButtonEnabled
            .drive(with: self, onNext: { owner, isEnabled in
                owner.rootView.genrePreferenceView.bottomButton.updateButtonEnabled(isEnabled)
            })
            .disposed(by: disposeBag)
        
        output.moveToOnboardingSuccessViewController
            .drive(with: self, onNext: { owner, nickname in
                owner.presentToOnboardingSuccessViewController(nickname: nickname)
            })
            .disposed(by: disposeBag)
        
        // Total
        output.stageIndex
            .drive(with: self, onNext: { owner, stage in
                owner.setNavigationBar(stage: stage)
            })
            .disposed(by: disposeBag)
        
        output.progressOffset
            .drive(with: self, onNext: { owner, offset in
                owner.rootView.progressView.updateProgressView(offset)
            })
            .disposed(by: disposeBag)
        
        output.moveToLastStage
            .drive(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
                owner.scrollToLastItem()
            })
            .disposed(by: disposeBag)
        
        output.moveToNextStage
            .drive(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
                owner.scrollToNextItem()
            })
            .disposed(by: disposeBag)
        
        output.showNetworkErrorView
            .drive(with: self, onNext: { owner, _ in
                owner.rootView.showNetworkErrorView()
            })
            .disposed(by: disposeBag)
        
        output.moveToLoginViewController
            .drive(with: self, onNext: { owner, _ in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                    return
                }
                sceneDelegate.setRootToLoginViewController()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func createViewModelInput() -> OnboardingViewModel.Input {
        let genderButtonDidTap = Observable.merge(
            rootView.birthGenderView.genderButtons
                .map { button in
                    button.rx.tap.map { button.gender }
                })
        
        let genreButtonDidTap = Observable.merge(
            self.rootView.genrePreferenceView.genreButtons
                .map { view in
                    view.genreButton.rx.tap.map { view.genre }
                }
        )
        
        let getNotificationBirth = NotificationCenter.default.rx.notification(NSNotification.Name("Birth"))
            .map { notification -> Int? in
                return notification.userInfo?["Birth"] as? Int
            }
        
        let nextButtonDidTap = Observable.merge(
            self.rootView.nickNameView.bottomButton.button.rx.tap.asObservable(),
            self.rootView.birthGenderView.bottomButton.button.rx.tap.asObservable(),
            self.rootView.genrePreferenceView.bottomButton.button.rx.tap.asObservable()
        )
        
        return OnboardingViewModel.Input(
            nicknameTextFieldEditingDidBegin: self.rootView.nickNameView.nicknameTextField.rx.controlEvent(.editingDidBegin),
            nicknameTextFieldEditingDidEnd: self.rootView.nickNameView.nicknameTextField.rx.controlEvent(.editingDidEnd),
            nicknameTextFieldText: self.rootView.nickNameView.nicknameTextField.rx.text.orEmpty.distinctUntilChanged(),
            textFieldInnerButtonDidTap: self.rootView.nickNameView.textFieldInnerButton.rx.tap,
            duplicateCheckButtonDidTap: self.rootView.nickNameView.duplicateCheckButton.rx.tap,
            genderButtonDidTap: genderButtonDidTap,
            selectBirthButtonDidTap: self.rootView.birthGenderView.selectBirthButton.rx.tap,
            selectedBirth: getNotificationBirth,
            genreButtonDidTap: genreButtonDidTap,
            nextButtonDidTap: nextButtonDidTap,
            backButtonDidTap: rootView.backButton.rx.tap,
            scrollViewContentOffset: self.rootView.scrollView.rx.contentOffset,
            skipButtonDidTap: rootView.skipButton.rx.tap,
            networkErrorRefreshButtonDidTap: rootView.networkErrrorView.refreshButton.rx.tap
        )
    }
    
    //MARK: - Custom Method
    
    private func scrollToNextItem() {
        let currentOffset = rootView.scrollView.contentOffset
        let width = UIScreen.main.bounds.width
        let nextOffset = currentOffset.x + width
        
        rootView.scrollView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
    }
    
    private func scrollToLastItem() {
        let currentOffset = rootView.scrollView.contentOffset
        let width = UIScreen.main.bounds.width
        let nextOffset = currentOffset.x - width
        
        rootView.scrollView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
    }
    
    private func setNavigationBar(stage: Int) {
        navigationItem.setHidesBackButton(stage == 0, animated: true)
        self.navigationItem.leftBarButtonItem = stage == 0 ? nil : UIBarButtonItem(customView: rootView.backButton)
        self.navigationItem.rightBarButtonItem = stage != 2 ? nil : UIBarButtonItem(customView: rootView.skipButton)
    }
}

extension OnboardingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }
}

