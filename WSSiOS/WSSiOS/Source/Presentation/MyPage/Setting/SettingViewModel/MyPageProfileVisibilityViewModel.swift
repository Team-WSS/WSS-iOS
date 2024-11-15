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
    private var isPublic: Bool = true
    
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
        let showChangeProfileToast = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.getUserProfileVisibility()
            .map { $0.isProfilePublic }
            .subscribe(with: self, onNext: { owner, isPublic in 
                owner.initStatus = isPublic
            })
            .disposed(by: disposeBag)
        
        input.isVisibilityToggleButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in 
                owner.isPublic.toggle()
                output.changePrivateToggleButton.accept(owner.isPublic)
                output.changeCompleteButton.accept(owner.initStatus != owner.isPublic)
            })
            .disposed(by: disposeBag)
        
        input.completeButtonDidTap
            .withUnretained(self)
            .filter { owner, _ in
                return owner.initStatus != owner.isPublic
            }
            .flatMap { owner, _ in
                owner.patchUserProfileVisibility(isProfilePublic: owner.isPublic)
                    .catch { error in
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                output.popViewControllerAction.accept(true)
                // TODO: - Toast Message 추가
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in 
                output.popViewControllerAction.accept(true)
                output.showChangeProfileToast.accept(owner.isPublic)
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
