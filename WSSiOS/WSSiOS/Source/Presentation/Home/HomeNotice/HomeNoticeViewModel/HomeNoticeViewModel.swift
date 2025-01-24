//
//  HomeNoticeViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import UIKit

import RxSwift
import RxCocoa

final class HomeNoticeViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let notificationRepository: NotificationRepository
    private let disposeBag = DisposeBag()
    
    private var isLoadable: Bool = false
    private var isFetching: Bool = false
    private var lastNotificationId: Int = 0
    private let notificationList = BehaviorRelay<[NotificationEntity]>(value: [])
    
    private let pushToFeedDetailViewController = PublishRelay<Int>()
    private let pushToNoticeDetailViewController = PublishRelay<Int>()
    private let showLoadingView = PublishRelay<Bool>()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let noticeTableViewContentSize: Observable<CGSize?>
        let noticeTableViewCellSelected: ControlEvent<IndexPath>
        let scrollReachedBottom: Observable<Bool>
    }
    
    // MARK: - Outputs
    
    struct Output {
        let notificationList: Observable<[NotificationEntity]>
        let noticeTableViewHeight: Driver<CGFloat>
        let pushToFeedDetailViewController: Observable<Int>
        let pushToNoticeDetailViewController: Observable<Int>
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
                self.lastNotificationId = data.notifications.count
                self.showLoadingView.accept(false)
            }, onError: { error in
                print("Error fetching notifications: \(error)")
                self.showLoadingView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.noticeTableViewCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                let isNotice = owner.notificationList.value[indexPath.row].isNotice
                if isNotice {
                    let notificationId = owner.notificationList.value[indexPath.row].notificationId
                    owner.pushToNoticeDetailViewController.accept(notificationId)
                } else {
                    let feedId = owner.notificationList.value[indexPath.row].feedId ?? -1
                    owner.pushToFeedDetailViewController.accept(feedId)
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
                owner.lastNotificationId += data.notifications.count
            })
            .disposed(by: disposeBag)
        
        let noticeTableViewHeight = input.noticeTableViewContentSize
            .map { $0?.height ?? 0 }
            .asDriver(onErrorJustReturn: 0)
        
        return Output(notificationList: notificationList.asObservable(),
                      noticeTableViewHeight: noticeTableViewHeight,
                      pushToFeedDetailViewController: pushToFeedDetailViewController.asObservable(),
                      pushToNoticeDetailViewController: pushToNoticeDetailViewController.asObservable(),
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
