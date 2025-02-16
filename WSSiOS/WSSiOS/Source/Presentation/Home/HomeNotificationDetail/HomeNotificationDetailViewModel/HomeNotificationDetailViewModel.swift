//
//  HomeNoticeDetailViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/6/24.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeNoticeDetailViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let notificationRepository: NotificationRepository
    private let disposeBag = DisposeBag()
    
    let notificationId: Int
    private let notificationData = PublishSubject<NotificationDetailEntity>()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    
    struct Output {
        let notificationData: Observable<NotificationDetailEntity>
    }
    
    //MARK: - init
    
    init(notificationRepository: NotificationRepository,
         notificationId: Int) {
        self.notificationRepository = notificationRepository
        self.notificationId = notificationId
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest {
                self.getNotificationDetail(notificationId: self.notificationId)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.notificationData.onNext(data)
            })
            .disposed(by: disposeBag)
        
        return Output(notificationData: self.notificationData.asObservable())
    }
    
    //MARK: - API
    
    func getNotificationDetail(notificationId: Int) -> Observable<NotificationDetailEntity> {
        return notificationRepository.getNotificationDetail(notificationId: notificationId)
    }
}
