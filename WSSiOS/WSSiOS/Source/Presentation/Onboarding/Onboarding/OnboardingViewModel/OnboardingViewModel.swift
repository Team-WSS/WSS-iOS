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
    private let nickname = BehaviorRelay<String>(value: "")
    private let isNicknameFieldEditing = BehaviorRelay<Bool>(value: false)
    private let isDuplicateCheckButtonEnabled = BehaviorRelay<Bool>(value: false)
    private let isNicknameAvailable = BehaviorRelay<NicknameAvailablity>(value: .notStarted)
    private let isNicknameNextButtonAvailable = BehaviorRelay<Bool>(value: false)
    
    // BirthGender
    private let selectedGender = BehaviorRelay<OnboardingGender?>(value: nil)
    private let selectedBirth = BehaviorRelay<Int?>(value: nil)
    private let isBirthGenderNextButtonAvailable = BehaviorRelay<Bool>(value: false)
    
    // GenrePreference
    private let selectedGenres = BehaviorRelay<[NewNovelGenre]>(value: [])
    private let isGenrePreferenceNextButtonAvailable = BehaviorRelay<Bool>(value: false)
    
    // Total
    private let moveToLastStage = PublishRelay<Void>()
    private let moveToNextStage = PublishRelay<Void>()
    private let moveToOnboardingSuccessViewController = PublishRelay<String>()
    private let stageIndex = BehaviorRelay<Int>(value: 0)
    private let progressOffset = BehaviorRelay<CGFloat>(value: 0)
    
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
        
        // GenrePreference
        let genreButtonDidTap: Observable<NewNovelGenre>
        
        // Total
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: ControlEvent<Void>
        let scrollViewContentOffset: ControlProperty<CGPoint>
        let skipButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        // Nickname
        let isNicknameTextFieldEditing: Driver<Bool>
        let isDuplicateCheckButtonEnabled: Driver<Bool>
        let nicknameAvailablity: Driver<NicknameAvailablity>
        let isNicknameNextButtonEnabled: Driver<Bool>
        
        // BirthGender
        let selectedGender: Driver<OnboardingGender?>
        let showDatePickerModal: Driver<Void>
        let isBirthGenderNextButtonEnabled: Driver<Bool>
        
        // GenrePrefernece
        let selectedGenres: Driver<[NewNovelGenre]>
        let isGenrePreferenceNextButtonEnabled: Driver<Bool>
        
        // Total
        let stageIndex: Driver<Int>
        let moveToLastStage: Driver<Void>
        let moveToNextStage: Driver<Void>
        let moveToOnboardingSuccessViewController: Driver<String>
        let progressOffset: Driver<CGFloat>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        // Nickname
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
            .withLatestFrom(input.nicknameTextFieldText)
            .bind(with: self, onNext: { owner, nickname in
                // API 연결 필요, 지금은 무조건 성공한다고 가정.
                owner.isNicknameAvailable.accept(.available)
                owner.nickname.accept(nickname)
            })
            .disposed(by: disposeBag)
        
        // BirthGender
        input.genderButtonDidTap
            .bind(with: self, onNext: { owner, selectedGender in
                owner.selectedGender.accept(selectedGender)
            })
            .disposed(by: disposeBag)
        
        let showDatePickerModal = input.selectBirthButtonDidTap.asDriver()
        
        self.selectedGender
            .bind(with: self, onNext: { owner, selectedGender in
                // DatePicker 관련된 것은 나중에 적용 예정, 지금은 성별만 선택하면 넘어갈 수 있음
                if selectedGender != nil {
                    owner.isBirthGenderNextButtonAvailable.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        // GenrePreference
        input.genreButtonDidTap
            .bind(with: self, onNext: { owner, genre in
                var selectedGenres = owner.selectedGenres.value
                if selectedGenres.contains(genre) {
                    selectedGenres.removeAll(where: { $0 == genre })
                } else {
                    selectedGenres.append(genre)
                }
                owner.selectedGenres.accept(selectedGenres)
                owner.isGenrePreferenceNextButtonAvailable.accept(!selectedGenres.isEmpty) 
            })
            .disposed(by: disposeBag)
        
        input.skipButtonDidTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(nickname)
            .bind(with: self, onNext: { owner, nickname in
                owner.moveToOnboardingSuccessViewController.accept(nickname)
            })
            .disposed(by: disposeBag)
        
        // Total
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
        
        input.nextButtonDidTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(stageIndex)
            .bind(with: self, onNext: { owner, stage in
                // 만든 부분까지만 보여주고, 바로 홈으로 이동. 지금은 1번까지 만들어져 있음.
                if stage >= 2 {
                    owner.moveToOnboardingSuccessViewController.accept(owner.nickname.value)
                } else if stage >= 0 {
                    owner.stageIndex.accept(stage + 1)
                    owner.moveToNextStage.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.scrollViewContentOffset
            .bind(with: self, onNext: { owner, offset in
                let screenWidth = UIScreen.main.bounds.width
                let offset = screenWidth - (offset.x + screenWidth)/3
                owner.progressOffset.accept(offset)
            })
            .disposed(by: disposeBag)
        
        return Output(
            isNicknameTextFieldEditing: isNicknameFieldEditing.asDriver(),
            isDuplicateCheckButtonEnabled: isDuplicateCheckButtonEnabled.asDriver(),
            nicknameAvailablity: isNicknameAvailable.asDriver(),
            isNicknameNextButtonEnabled: isNicknameNextButtonAvailable.asDriver(),
            selectedGender: selectedGender.asDriver(),
            showDatePickerModal: showDatePickerModal,
            isBirthGenderNextButtonEnabled: isBirthGenderNextButtonAvailable.asDriver(),
            selectedGenres: selectedGenres.asDriver(),
            isGenrePreferenceNextButtonEnabled: isGenrePreferenceNextButtonAvailable.asDriver(),
            stageIndex: stageIndex.asDriver(),
            moveToLastStage: moveToLastStage.asDriver(onErrorJustReturn: ()),
            moveToNextStage: moveToNextStage.asDriver(onErrorJustReturn: ()),
            moveToOnboardingSuccessViewController: moveToOnboardingSuccessViewController.asDriver(onErrorJustReturn: "Error"),
            progressOffset: progressOffset.asDriver()
        )
    }
}
