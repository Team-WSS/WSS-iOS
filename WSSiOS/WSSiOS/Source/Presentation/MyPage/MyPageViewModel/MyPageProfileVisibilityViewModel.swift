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
    private var currentStatus: Bool = true
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        
        self.getUserProfileVisibility()
            .map { $0.isProfilePublic }
            .subscribe(with: self, onNext: { owner, isPublic in 
                owner.initStatus = isPublic
            })
            .disposed(by: disposeBag)
        
        self.currentStatus = self.initStatus
    }
    
    struct Input {
        let isVisibilityToggleButtonDidTap: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
        let completeButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {        
        let changePrivateToggleButton = PublishRelay<Bool>()
        let popViewControllerAction = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.isVisibilityToggleButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in 
                owner.currentStatus.toggle()
                output.changePrivateToggleButton.accept(owner.currentStatus)
            })
            .disposed(by: disposeBag)
        
        input.completeButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in 
                guard owner.initStatus == owner.currentStatus else { return }
                
                owner.patchUserProfileVisibility(isProfilePublic: owner.currentStatus)
                    .subscribe(onNext: {
                        output.popViewControllerAction.accept(true)
                    }, onError: { error in
                        print(error)
                    })
                    .disposed(by: owner.disposeBag)
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



