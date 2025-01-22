//
//  MyPagePushNotificationViewModel.swift
//  WSSiOS
//
//  Created by YunhakLee on 1/22/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPagePushNotificationViewModel: ViewModelType {

    //MARK: - Properties
    
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    private let activePushIsEnabled = BehaviorRelay<Bool>(value: true)
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    struct Input {
        let activePushSettingSectionDidTap: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
        let activePushIsEnabled: Driver<Bool>
    }
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        input.activePushSettingSectionDidTap
            .withLatestFrom(activePushIsEnabled)
            .bind(with: self, onNext: { owner, isEnalbed in
                owner.activePushIsEnabled.accept(!isEnalbed)
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            activePushIsEnabled: activePushIsEnabled.asDriver()
        )
    }
}
