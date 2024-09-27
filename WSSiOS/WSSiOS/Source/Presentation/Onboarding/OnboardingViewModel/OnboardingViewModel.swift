//
//  OnboardingViewModel.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/27/24.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift


enum NicknameAvailablity {
    case available
    case notAvailable
    case unknown
    case notStarted
}

final class OnboardingViewModel: ViewModelType {
    
    //MARK: - Properties
    
    // Nickname
    let isNicknameFieldEditing = BehaviorRelay<Bool>(value: false)
    let isDuplicateCheckButtonEnabled = BehaviorRelay<Bool>(value: false)
    let isNicknameAvailable = BehaviorRelay<NicknameAvailablity>(value: .notStarted)
    let isNicknameNextButtonAvailable = BehaviorRelay<Bool>(value: false)
    
    // BirthGender
    let selectedGender = BehaviorRelay<OnboardingGender?>(value: nil)
    let selectedBirth = BehaviorRelay<Int?>(value: nil)
    let isBirthGenderNextButtonAvailable = BehaviorRelay<Bool>(value: false)
    
    // Total
    let moveToLastStage = PublishRelay<Void>()
    let moveToNextStage = PublishRelay<Void>()
    let moveToHomeViewController = PublishRelay<Void>()
    let stageIndex = BehaviorRelay<Int>(value: 0)
    
    //MARK: - Life Cycle
    
    
    //MARK: - Transform
    
    struct Input {
        // Nickname
        let nicknameTextFieldEditingDidBegin: ControlEvent<Void>
        let nicknameTextFieldEditingDidEnd: ControlEvent<Void>
        let nicknameTextFieldText: Observable<String>
        let duplicateCheckButtonDidTap: ControlEvent<Void>
        
        // BirthGender
        let genderButtonDidTap: Observable<OnboardingGender>
        let selectBirthButtonDidTap: ControlEvent<Void>
        
        // Total
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        // Nickname
        let isNicknameTextFieldEditing: Driver<Bool>
        let isDuplicateCheckButtonEnabled: Driver<Bool>
        let nicknameAvailablity: Driver<NicknameAvailablity>
        let isNicknameNextButtonAvailable: Driver<Bool>
        
        // BirthGender
        let selectedGender: Driver<OnboardingGender?>
        let showDatePickerModal: Driver<Void>
        let isBirthGenderNextButtonAvailable: Driver<Bool>
        
        // Total
        let stageIndex: Driver<Int>
        let moveToLastStage: Driver<Void>
        let moveToNextStage: Driver<Void>
        let moveToHomeViewController: Driver<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.backButtonDidTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(stageIndex)
            .bind(with: self, onNext: { owner, stage in
                if stage > 0 {
                    owner.stageIndex.accept(stage - 1)
                    owner.moveToLastStage.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.nicknameTextFieldEditingDidBegin
            .bind(with: self, onNext: { owner, _ in
                owner.isNicknameFieldEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.nicknameTextFieldEditingDidEnd
            .withLatestFrom(input.nicknameTextFieldText)
            .bind(with: self, onNext: { owner, text in
                owner.isNicknameFieldEditing.accept(!text.isEmpty)
            })
            .disposed(by: disposeBag)
        
        input.nicknameTextFieldText
            .bind(with: self, onNext: { owner, text in
                if text.isEmpty {
                    owner.isNicknameAvailable.accept(.notStarted)
                } else if text.count >= 2 && text.count <= 10 {
                    owner.isNicknameAvailable.accept(.unknown)
                } else {
                    owner.isNicknameAvailable.accept(.notAvailable)
                }
            })
            .disposed(by: disposeBag)
        
        self.isNicknameAvailable
            .bind(with: self, onNext: { owner, availablity in
                owner.isDuplicateCheckButtonEnabled.accept(availablity == .unknown)
                owner.isNicknameNextButtonAvailable.accept(availablity == .available)
            })
            .disposed(by: disposeBag)
        
        input.duplicateCheckButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                // API 연결 필요, 지금은 무조건 성공한다고 가정.
                owner.isNicknameAvailable.accept(.available)
            })
            .disposed(by: disposeBag)
        
        input.genderButtonDidTap
            .bind(with: self, onNext: { owner, selectedGender in
                owner.selectedGender.accept(selectedGender)
            })
            .disposed(by: disposeBag)
        
        let showDatePickerModal = input.selectBirthButtonDidTap.asDriver()
        
        self.selectedGender
            .bind(with: self, onNext: { owner, selectedGender in
                if selectedGender != nil {
                    owner.isBirthGenderNextButtonAvailable.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(stageIndex)
            .bind(with: self, onNext: { owner, stage in
                // 만든 부분까지만 보여주고, 바로 홈으로 이동. 지금은 1번까지 만들어져 있음.
                if stage >= 1 {
                    owner.moveToHomeViewController.accept(())
                } else if stage >= 0 {
                    owner.stageIndex.accept(stage + 1)
                    owner.moveToNextStage.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            isNicknameTextFieldEditing: isNicknameFieldEditing.asDriver(),
            isDuplicateCheckButtonEnabled: isDuplicateCheckButtonEnabled.asDriver(),
            nicknameAvailablity: isNicknameAvailable.asDriver(),
            isNicknameNextButtonAvailable: isNicknameNextButtonAvailable.asDriver(),
            selectedGender: selectedGender.asDriver(),
            showDatePickerModal: showDatePickerModal,
            isBirthGenderNextButtonAvailable: isBirthGenderNextButtonAvailable.asDriver(),
            stageIndex: stageIndex.asDriver(),
            moveToLastStage: moveToLastStage.asDriver(onErrorJustReturn: ()),
            moveToNextStage: moveToNextStage.asDriver(onErrorJustReturn: ()),
            moveToHomeViewController: moveToHomeViewController.asDriver(onErrorJustReturn: ())
        )
    }
}
