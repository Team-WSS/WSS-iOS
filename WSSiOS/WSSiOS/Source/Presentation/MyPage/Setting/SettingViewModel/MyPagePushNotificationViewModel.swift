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
    
    private let notificationRepository: NotificationRepository
    private let disposeBag = DisposeBag()
    
    private let activePushIsEnabled = BehaviorRelay<Bool>(value: true)
    
    //MARK: - Life Cycle
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let activePushSettingSectionDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let activePushIsEnabled: Driver<Bool>
    }
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        input.viewWillAppearEvent
            .bind(with: self, onNext: { owner, _ in
                owner.getUserPushNotificationSetting()
            })
            .disposed(by: disposeBag)
        
            
        input.activePushSettingSectionDidTap
            .withLatestFrom(activePushIsEnabled)
            .bind(with: self, onNext: { owner, isEnalbed in
                owner.postUserPushNotificationSetting(isPushEnabled: !isEnalbed)
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            activePushIsEnabled: activePushIsEnabled.asDriver()
        )
    }
    
    func getUserPushNotificationSetting() {
        notificationRepository.getUserPushNotificationSetting()
            .subscribe(with: self, onSuccess: { owner, data in
                owner.activePushIsEnabled.accept(data.isPushEnabled)
            }, onFailure: { onwer, error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func postUserPushNotificationSetting(isPushEnabled: Bool) {
        notificationRepository.postUserPushNotificationSetting(isPushEnabled: isPushEnabled)
            .subscribe(with: self, onSuccess: { owner, _ in
                owner.activePushIsEnabled.accept(isPushEnabled)
            })
            .disposed(by: disposeBag)
    }
}
