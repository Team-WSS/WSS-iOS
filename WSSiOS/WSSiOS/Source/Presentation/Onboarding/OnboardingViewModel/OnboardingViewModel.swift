//
//  OnboardingViewModel.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/27/24.
//

import Foundation

import RxSwift
import RxCocoa
import Then

enum NicknameAvailablity {
    case available
    case notAvailable
    case unknown
    case notStarted
}

final class OnboardingViewModel: ViewModelType {
    
    //MARK: - Properties
    
    let isNicknameFieldEditing = BehaviorRelay<Bool>(value: false)
    let isDuplicateCheckButtonEnabled = BehaviorRelay<Bool>(value: false)
    let isNicknameAvailable = BehaviorRelay<NicknameAvailablity>(value: .notStarted)
    let isNextButtonAvailable = BehaviorRelay<Bool>(value: false)
    
    //MARK: - Life Cycle
    
    
    //MARK: - Transform
    
    struct Input {
        let nicknameTextFieldEditingDidBegin: ControlEvent<Void>
        let nicknameTextFieldEditingDidEnd: ControlEvent<Void>
        let nicknameTextFieldText: Observable<String>
        let duplicateCheckButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let isNicknameTextFieldEditing: Driver<Bool>
        let isDuplicateCheckButtonEnabled: Driver<Bool>
        let isNicknameAvailable: Driver<NicknameAvailablity>
        let isNextButtonAvailable: Driver<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
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
                owner.isNextButtonAvailable.accept(availablity == .available)
            })
            .disposed(by: disposeBag)
        
        input.duplicateCheckButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                // API 연결 필요, 지금은 무조건 성공한다고 가정.
                owner.isNicknameAvailable.accept(.available)
            })
            .disposed(by: disposeBag)
        
        return Output(
            isNicknameTextFieldEditing: isNicknameFieldEditing.asDriver(),
            isDuplicateCheckButtonEnabled: isDuplicateCheckButtonEnabled.asDriver(),
            isNicknameAvailable: isNicknameAvailable.asDriver(),
            isNextButtonAvailable: isNextButtonAvailable.asDriver()
        )
    }
}
