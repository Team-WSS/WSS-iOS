//
//  MyPageChangeUserInfoViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 9/20/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageChangeUserInfoViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let userRepository: UserRepository
    private let gender: String
    private let birth: String
    
    private var currentGender = ""
    private var currentBirth = ""
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository, gender: String, birth: String) {
        self.userRepository = userRepository
        self.gender = gender
        self.birth = birth
        
        self.currentGender = self.gender
        self.currentBirth = self.birth
    }
    
    struct Input {
        let maleButtonTapped: ControlEvent<Void>
        let femaleButtonTapped: ControlEvent<Void>
        let birthViewTapped: ControlEvent<Void>
        let completeButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let changeGender = BehaviorRelay<Int>(value: 0)
        let showBottomSheet = PublishRelay<Bool>()
        let changeCompleteButton = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.maleButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                output.changeGender.accept(0)
                output.changeCompleteButton.accept(owner.checkIsEnabledCompleteButton())
            })
            .disposed(by: disposeBag)
        
        input.femaleButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                output.changeGender.accept(1)
                output.changeCompleteButton.accept(owner.checkIsEnabledCompleteButton())
            })
            .disposed(by: disposeBag)
        
        input.birthViewTapped
            .subscribe(with: self, onNext: { owner, _ in
                output.showBottomSheet.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.completeButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                //서버통신
            })
            .disposed(by: disposeBag)
 
        return output
    }
    
    //MARK: - API
    
    //MARK: - Custom Method
    
    private func checkIsEnabledCompleteButton() -> Bool {
        return !(gender == currentBirth && birth == currentBirth)
    }
}

