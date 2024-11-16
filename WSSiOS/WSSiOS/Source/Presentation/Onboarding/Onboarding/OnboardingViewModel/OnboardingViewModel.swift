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


final class OnboardingViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let nicknamePattern = "^[a-zA-Z0-9가-힣]{2,10}$"
    private let onboardingRepository: OnboardingRepository
    
    // Nickname
    private let nicknameText = BehaviorRelay<String>(value: "")
    private let isNicknameFieldEditing = BehaviorRelay<Bool>(value: false)
    private let nicknameTextFieldClear = PublishRelay<Void>()
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
    private let endOnboarding = PublishRelay<Void>()
    private let moveToOnboardingSuccessViewController = PublishRelay<String>()
    private let stageIndex = BehaviorRelay<Int>(value: 0)
    private let progressOffset = BehaviorRelay<CGFloat>(value: 0)
    private let showNetworkErrorView = PublishRelay<Void>()
    private let moveToLoginViewController = PublishRelay<Void>()
    
    //MARK: - Life Cycle
    
    init(onboardingRepository: OnboardingRepository) {
        self.onboardingRepository = onboardingRepository
    }
    
    //MARK: - Transform
    
    struct Input {
        // Nickname
        let nicknameTextFieldEditingDidBegin: ControlEvent<Void>
        let nicknameTextFieldEditingDidEnd: ControlEvent<Void>
        let nicknameTextFieldText: Observable<String>
        let textFieldInnerButtonDidTap: ControlEvent<Void>
        let duplicateCheckButtonDidTap: ControlEvent<Void>
        
        // BirthGender
        let genderButtonDidTap: Observable<OnboardingGender>
        let selectBirthButtonDidTap: ControlEvent<Void>
        let selectedBirth: Observable<Int?>
        
        // GenrePreference
        let genreButtonDidTap: Observable<NewNovelGenre>
        
        // Total
        let nextButtonDidTap: Observable<Void>
        let backButtonDidTap: ControlEvent<Void>
        let scrollViewContentOffset: ControlProperty<CGPoint>
        let skipButtonDidTap: ControlEvent<Void>
        let networkErrorRefreshButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        // Nickname
        let isNicknameTextFieldEditing: Driver<Bool>
        let nicknameTextFieldClear: Driver<Void>
        let isDuplicateCheckButtonEnabled: Driver<Bool>
        let nicknameAvailablity: Driver<NicknameAvailablity>
        let isNicknameNextButtonEnabled: Driver<Bool>
        
        // BirthGender
        let selectedGender: Driver<OnboardingGender?>
        let showBirthPickerModal: Driver<Void>
        let selectedBirth: Driver<Int?>
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
        let showNetworkErrorView: Driver<Void>
        let moveToLoginViewController: Driver<Void>
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
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, text in
                owner.checkNicknameAvailability(text)
            })
            .disposed(by: disposeBag)
        
        self.isNicknameAvailable
            .bind(with: self, onNext: { owner, availablity in
                owner.isDuplicateCheckButtonEnabled.accept(availablity == .unknown)
                owner.isNicknameNextButtonAvailable.accept(availablity == .available)
            })
            .disposed(by: disposeBag)
        
        self.isNicknameAvailable
            .filter { $0 == .available }
            .withLatestFrom(input.nicknameTextFieldText)
            .bind(with: self, onNext: { owner, nickname in
                owner.nicknameText.accept(nickname)
            })
            .disposed(by: disposeBag)
        
        input.textFieldInnerButtonDidTap
            .bind(with: self, onNext: { owner, availablity in
                owner.nicknameTextFieldClear.accept(())
                owner.isNicknameAvailable.accept(.notStarted)
            })
            .disposed(by: disposeBag)
        
        input.duplicateCheckButtonDidTap
            .withLatestFrom(input.nicknameTextFieldText)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, nickname in
                owner.checkNicknameisValid(nickname, disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        // BirthGender
        input.genderButtonDidTap
            .bind(with: self, onNext: { owner, selectedGender in
                owner.selectedGender.accept(selectedGender)
            })
            .disposed(by: disposeBag)
        
        let showBirthPickerModal = input.selectBirthButtonDidTap.asDriver()
        
        Observable
            .combineLatest(selectedGender.asObservable(), selectedBirth.asObservable())
            .bind(with: self, onNext: { owner, value in
                let (gender, birth) = value
                if gender != nil && birth != nil {
                    owner.isBirthGenderNextButtonAvailable.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        input.selectedBirth
            .bind(with: self, onNext: { owner, birth in
                owner.selectedBirth.accept(birth)
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
            .withLatestFrom(nicknameText)
            .bind(with: self, onNext: { owner, nickname in
                owner.endOnboarding.accept(())
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
                if stage >= 2 {
                    owner.endOnboarding.accept(())
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
        
        endOnboarding
            .bind(with: self, onNext: { owner, _ in
                owner.postUserProfile(disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.networkErrorRefreshButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                UserDefaults.standard.setValue(nil,
                                               forKey: StringLiterals.UserDefault.accessToken)
                UserDefaults.standard.setValue(nil,
                                               forKey: StringLiterals.UserDefault.refreshToken)
                owner.moveToLoginViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            isNicknameTextFieldEditing: isNicknameFieldEditing.asDriver(),
            nicknameTextFieldClear: nicknameTextFieldClear.asDriver(onErrorJustReturn: ()),
            isDuplicateCheckButtonEnabled: isDuplicateCheckButtonEnabled.asDriver(),
            nicknameAvailablity: isNicknameAvailable.asDriver(),
            isNicknameNextButtonEnabled: isNicknameNextButtonAvailable.asDriver(),
            selectedGender: selectedGender.asDriver(),
            showBirthPickerModal: showBirthPickerModal,
            selectedBirth: selectedBirth.asDriver(),
            isBirthGenderNextButtonEnabled: isBirthGenderNextButtonAvailable.asDriver(),
            selectedGenres: selectedGenres.asDriver(),
            isGenrePreferenceNextButtonEnabled: isGenrePreferenceNextButtonAvailable.asDriver(),
            stageIndex: stageIndex.asDriver(),
            moveToLastStage: moveToLastStage.asDriver(onErrorJustReturn: ()),
            moveToNextStage: moveToNextStage.asDriver(onErrorJustReturn: ()),
            moveToOnboardingSuccessViewController: moveToOnboardingSuccessViewController.asDriver(onErrorJustReturn: "Error"),
            progressOffset: progressOffset.asDriver(),
            showNetworkErrorView: showNetworkErrorView.asDriver(onErrorJustReturn: ()),
            moveToLoginViewController: moveToLoginViewController.asDriver(onErrorJustReturn: ())
        )
    }
    
    //MARK: - Custom Method
    
    private func checkNicknameAvailability(_ nickname: String) {
        if nickname.isEmpty {
            self.isNicknameAvailable.accept(.notStarted)
        } else if !self.isValidNicknameCharacters(nickname) {
            if nickname.contains(where: { $0 == " " }) {
                self.isNicknameAvailable.accept(
                    .notAvailable(reason: .whiteSpaceIncluded)
                )
            } else {
                self.isNicknameAvailable.accept(
                    .notAvailable(reason: .invalidChacterOrLimitExceeded)
                )
            }
        } else {
            self.isNicknameAvailable.accept(.unknown)
        }
    }
    
    private func isValidNicknameCharacters(_ text: String) -> Bool {
        return text.range(of: nicknamePattern, options: .regularExpression) != nil
    }
    
    private func checkNicknameisValid(_ nickname: String, disposeBag: DisposeBag) {
        self.onboardingRepository.getNicknameisValid(nickname)
            .map { $0.isValid }
            .subscribe(with: self, onSuccess: { owner, isValid in
                if isValid {
                    owner.isNicknameAvailable.accept(.available)
                } else {
                    owner.isNicknameAvailable.accept(
                        .notAvailable(reason: .duplicated)
                    )
                }
            }, onFailure: { owner, error in
                guard let networkError = error as? RxCocoaURLError else {
                    owner.showNetworkErrorView.accept(())
                    return
                }
                
                switch networkError {
                case .httpRequestFailed(_, let data):
                    if let data,
                       let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                        owner.acceptNicknameNotAvailableReason(from: errorResponse.code)
                    } else {
                        owner.showNetworkErrorView.accept(())
                    }
                default:
                    owner.showNetworkErrorView.accept(())
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func acceptNicknameNotAvailableReason(from code: String) {
        let reason: NicknameNotAvailableReason
        switch code {
        case "USER-003":
            reason = .whiteSpaceIncluded
        case "USER-014":
            reason = .notChanged
        default:
            reason = .invalidChacterOrLimitExceeded
        }
        
        self.isNicknameAvailable.accept(.notAvailable(reason: reason))
    }
    
    private func postUserProfile(disposeBag: DisposeBag) {
        guard let gender = self.selectedGender.value,
              let birth = self.selectedBirth.value else {
            print("RetrunToGenderBirthPage")
            return
        }
        
        self.onboardingRepository.postUserProfile(
            nickname: self.nicknameText.value,
            gender: gender,
            birth: birth,
            genrePreferences: self.selectedGenres.value
        )
        .subscribe(with: self, onSuccess: { owner, _ in
            UserDefaults.standard.setValue(gender.rawValue,
                                           forKey: StringLiterals.UserDefault.userGender)
            UserDefaults.standard.setValue(self.nicknameText.value,
                                           forKey: StringLiterals.UserDefault.userNickname)
            UserDefaults.standard.setValue(true,
                                           forKey: StringLiterals.UserDefault.isRegister)
            owner.moveToOnboardingSuccessViewController.accept(owner.nicknameText.value)
        }, onFailure: { owner, error in
            owner.showNetworkErrorView.accept(())
            print(error)
        })
        .disposed(by: disposeBag)
    }
}
