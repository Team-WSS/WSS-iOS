//
//  MyPageProfileVisibilityViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 9/18/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageProfileVisibilityViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    //초기값 부여
    private var initStatus: Bool = true
    private var isStatusRelay = BehaviorRelay<Bool>(value: true)
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    struct Input {
        let isVisibilityToggleButtonDidTap: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
        let completeButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let changePrivateToggleButton = PublishRelay<Bool>()
        let changeCompleteButton = PublishRelay<Bool>()
        let popViewControllerAction = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.getUserProfileVisibility()
            .map { $0.isProfilePublic }
            .subscribe(with: self, onNext: { owner, isPublic in
                owner.initStatus = isPublic
                owner.isStatusRelay.accept(isPublic)
            })
            .disposed(by: disposeBag)
        
        input.isVisibilityToggleButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                let currentValue = owner.isStatusRelay.value
                owner.isStatusRelay.accept(!currentValue)
            })
            .disposed(by: disposeBag)
        
        self.isStatusRelay
            .subscribe(with: self, onNext: { owner, status in
                output.changePrivateToggleButton.accept(status)
                output.changeCompleteButton.accept(owner.initStatus != status)
            })
            .disposed(by: disposeBag)
        
        input.completeButtonDidTap
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.patchUserProfileVisibility(isProfilePublic: owner.isStatusRelay.value)
                    .catch { error in
                        return Observable.empty()
                    }
            }
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: NSNotification.Name("ChangeVisibility"), object: owner.isStatusRelay.value)
                output.popViewControllerAction.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.popViewControllerAction.accept(true)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    //MARK: - Custom Method
    
    //MARK: - API
    
    private func getUserProfileVisibility() -> Observable<UserProfileVisibility> {
        return userRepository.getUserProfileVisibility()
    }
    
    private func patchUserProfileVisibility(isProfilePublic: Bool) -> Observable<Void> {
        return userRepository.patchUserProfileVisibility(isProfilePublic: isProfilePublic)
    }
}
