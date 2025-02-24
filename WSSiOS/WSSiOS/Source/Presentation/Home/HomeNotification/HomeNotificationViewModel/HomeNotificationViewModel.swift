//
//  HomeNotificationViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import UIKit

import RxSwift
import RxCocoa

final class HomeNotificationViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let notificationRepository: NotificationRepository
    private let disposeBag = DisposeBag()
    
    private var isLoadable: Bool = false
    private var isFetching: Bool = false
    private var lastNotificationId: Int = 0
    private let notificationList = BehaviorRelay<[NotificationEntity]>(value: [])
    
    private let pushToFeedDetailViewController = PublishRelay<Int>()
    private let pushToNotificationDetailViewController = PublishRelay<Int>()
    private let showLoadingView = PublishRelay<Bool>()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let notificationTableViewContentSize: Observable<CGSize?>
        let notificationTableViewCellSelected: ControlEvent<IndexPath>
        let scrollReachedBottom: Observable<Bool>
    }
    
    // MARK: - Outputs
    
    struct Output {
        let notificationList: Observable<[NotificationEntity]>
        let notificationTableViewHeight: Driver<CGFloat>
        let pushToFeedDetailViewController: Observable<Int>
        let pushToNotificationDetailViewController: Observable<Int>
        let showLoadingView: Observable<Bool>
    }
    
    //MARK: - init
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .do(onNext: {
                self.isLoadable = false
                self.isFetching = false
                self.lastNotificationId = 0
                self.showLoadingView.accept(true)
            })
            .flatMapLatest {
                return self.getNotifications(lastNotificationId: self.lastNotificationId)
            }
            .subscribe(onNext: { data in
                self.notificationList.accept(data.notifications)
                self.isLoadable = data.isLoadable
                if let lastNotification = data.notifications.last {
                    self.lastNotificationId = lastNotification.notificationId
                }
                self.showLoadingView.accept(false)
            }, onError: { error in
                print("Error fetching notifications: \(error)")
                self.showLoadingView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.notificationTableViewCellSelected
            .map { indexPath -> NotificationEntity in
                return self.notificationList.value[indexPath.row]
            }
            .subscribe(with: self, onNext: { owner, notification in
                let notificationId = notification.notificationId
                if notification.isNotice {
                    owner.pushToNotificationDetailViewController.accept(notificationId)
                } else if notification.isRead {
                    owner.pushToFeedDetailViewController.accept(notification.feedId ?? -1)
                } else {
                    self.postNotificationRead(notificationId: notificationId)
                        .subscribe(onCompleted: {
                            self.pushToFeedDetailViewController.accept(notification.feedId ?? -1)
                        })
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        input.scrollReachedBottom
            .filter { reachedBottom in
                return reachedBottom && !self.isFetching && self.isLoadable
            }
            .do(onNext: { _ in
                self.isFetching = true
            })
            .flatMapLatest { _ in
                return self.getNotifications(lastNotificationId: self.lastNotificationId)
                    .do(onNext: { _ in
                        self.isFetching = false
                    }, onError: { _ in
                        self.isFetching = false
                    })
            }
            .subscribe(with: self, onNext: { owner, data in
                let newData = owner.notificationList.value + data.notifications
                owner.notificationList.accept(newData)
                owner.isLoadable = data.isLoadable
                if let lastNotification = data.notifications.last {
                    owner.lastNotificationId = lastNotification.notificationId
                }
            })
            .disposed(by: disposeBag)
        
        let notificationTableViewHeight = input.notificationTableViewContentSize
            .map { $0?.height ?? 0 }
            .asDriver(onErrorJustReturn: 0)
        
        return Output(notificationList: notificationList.asObservable(),
                      notificationTableViewHeight: notificationTableViewHeight,
                      pushToFeedDetailViewController: pushToFeedDetailViewController.asObservable(),
                      pushToNotificationDetailViewController: pushToNotificationDetailViewController.asObservable(),
                      showLoadingView: showLoadingView.asObservable())
    }
    
    //MARK: - API
    
    private func getNotifications(lastNotificationId: Int) -> Observable<NotificationsEntity> {
        return notificationRepository.getNotifications(lastNotificationId: lastNotificationId)
    }
    
    private func postNotificationRead(notificationId: Int) -> Observable<Void> {
        return notificationRepository.postNotificationRead(notificationId: notificationId)
    }
}
