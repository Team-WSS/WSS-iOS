//
//  MyPageChangeUserInfoViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 9/20/24.
//

import UIKit

import RxSwift
import RxCocoa

enum Gender {
    static let male = "M"
    static let female = "F"
}

final class MyPageChangeUserInfoViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let userRepository: UserRepository
    
    private let gender = UserDefaults.standard.string(forKey: StringLiterals.UserDefault.userGender) ?? ""
    private let birth = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userBirth)
    
    private var currentGender = ""
    private var currentBirth = 0
    private var isEnabledCompleteButton = BehaviorRelay<Bool>(value: true)
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    struct Input {
        let maleButtonTapped: ControlEvent<Void>
        let femaleButtonTapped: ControlEvent<Void>
        let birthViewTapped: ControlEvent<UITapGestureRecognizer>
        let backButtonTapped: ControlEvent<Void>
        let completeButtonTapped: ControlEvent<Void>
        let getNotificationUserBirth: Observable<Int>
    }
    
    struct Output {
        let dataBind = BehaviorRelay<ChangeUserInfo>(value: ChangeUserInfo(gender: "", 
                                                                           birth: 0))
        let changeGender = BehaviorRelay<String>(value: "")
        let showBottomSheet = PublishRelay<Int>()
        let changeCompleteButton = BehaviorRelay<Bool>(value: false)
        let popViewController = PublishRelay<Void>()
        let changeBirth = PublishRelay<Int>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        output.dataBind.accept(ChangeUserInfo(gender: self.gender, birth: self.birth))
        self.currentGender = self.gender
        self.currentBirth = self.birth
        
        input.maleButtonTapped
            .bind(with: self, onNext: { owner, _ in
                owner.currentGender = Gender.male
                output.changeGender.accept(Gender.male)
                output.changeCompleteButton.accept(owner.checkIsEnabledCompleteButton())
            })
            .disposed(by: disposeBag)
        
        input.femaleButtonTapped
            .bind(with: self, onNext: { owner, _ in
                owner.currentGender = Gender.female
                output.changeGender.accept(Gender.female)
                output.changeCompleteButton.accept(owner.checkIsEnabledCompleteButton())
            })
            .disposed(by: disposeBag)
        
        input.birthViewTapped
            .bind(with: self, onNext: { owner, _ in
                output.showBottomSheet.accept(owner.currentBirth)
            })
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                output.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.completeButtonTapped
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                let isEnabled = output.changeCompleteButton.value
                if isEnabled {
                    owner.putUserInfo(gender: owner.currentGender, birth: owner.currentBirth)
                        .subscribe(with: self, onNext: { owner, _ in
                            UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userGender)
                            UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userBirth)
                            
                            UserDefaults.standard.set(owner.currentGender, forKey: StringLiterals.UserDefault.userGender)
                            UserDefaults.standard.set(owner.currentBirth, forKey: StringLiterals.UserDefault.userBirth)
                            output.popViewController.accept(())
                        }, onError: { owner, error in
                            print(error)
                        })
                        .disposed(by: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        input.getNotificationUserBirth
            .bind(with: self, onNext: { owner, userBirth in
                owner.currentBirth = userBirth
                output.changeBirth.accept(userBirth)
                output.changeCompleteButton.accept(owner.checkIsEnabledCompleteButton())
                
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - API
    
    private func putUserInfo(gender: String, birth: Int) -> Observable<Void> {
        return userRepository.putUserInfo(gender: gender, birth: birth) 
            .observe(on: MainScheduler.instance)
    }
    
    //MARK: - Custom Method
    
    private func checkIsEnabledCompleteButton() -> Bool {
        return self.gender != currentGender || self.birth != currentBirth
    }
}

