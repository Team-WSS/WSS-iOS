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

final class OnboardingViewModel: ViewModelType {
    
    //MARK: - Properties
    
    let isKeywordTextFieldEditing = BehaviorRelay<Bool>(value: false)
    let isDuplicateCheckButtonEnabled = BehaviorRelay<Bool>(value: false)
    
    //MARK: - Life Cycle
    
    
    //MARK: - Transform
    
    struct Input {
        let nickNameTextFieldEditingDidBegin: ControlEvent<Void>
        let nickNameTextFieldEditingDidEnd: ControlEvent<Void>
        let nickNameTextFieldText: Observable<String>
    }
    
    struct Output {
        let isKeywordTextFieldEditing: Driver<Bool>
        let isDuplicateCheckButtonEnabled: Driver<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.nickNameTextFieldEditingDidBegin
            .bind(with: self, onNext: { owner, _ in
                owner.isKeywordTextFieldEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.nickNameTextFieldEditingDidEnd
            .withLatestFrom(input.nickNameTextFieldText)
            .bind(with: self, onNext: { owner, text in
                owner.isKeywordTextFieldEditing.accept(!text.isEmpty)
            })
            .disposed(by: disposeBag)
        
        input.nickNameTextFieldText
            .bind(with: self, onNext: { owner, text in
                owner.isDuplicateCheckButtonEnabled.accept(!text.isEmpty)
            })
            .disposed(by: disposeBag)
        
        return Output(
            isKeywordTextFieldEditing: isKeywordTextFieldEditing.asDriver(),
            isDuplicateCheckButtonEnabled: isDuplicateCheckButtonEnabled.asDriver()
        )
    }
    
  
}
