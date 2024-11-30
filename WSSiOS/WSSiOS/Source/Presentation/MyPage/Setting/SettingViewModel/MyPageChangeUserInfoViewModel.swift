//
//  MyPageChangeUserInfoViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 9/20/24.
//

import Foundation
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
    private let userInfo: ChangeUserInfo
    
    private var currentGender = ""
    private var currentBirth = 0
    private var isEnabledCompleteButton = BehaviorRelay<Bool>(value: true)
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository, userInfo: ChangeUserInfo) {
        self.userRepository = userRepository
        self.userInfo = userInfo
        
        self.currentGender = self.userInfo.gender
        self.currentBirth = self.userInfo.birth
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
        
        output.dataBind.accept(self.userInfo)
        
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
            .filter { output.changeCompleteButton.value }
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.putUserInfo(gender: self.currentGender, birth: self.currentBirth)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] in
                    guard let self = self else { return }
                    UserDefaults.standard.removeObject(forKey: StringLiterals.UserDefault.userGender)
                    UserDefaults.standard.setValue(self.currentGender, forKey: StringLiterals.UserDefault.userGender)
                    
                    output.popViewController.accept(())
                },
                onError: { error in
                    print((error.localizedDescription))
                }
            )
            .disposed(by: disposeBag)
        
        input.getNotificationUserBirth
            .bind(with: self, onNext: { owner, birth in
                owner.currentBirth = birth
                output.changeBirth.accept(birth)
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
        return userInfo.gender != currentGender || userInfo.birth != currentBirth
    }
}

