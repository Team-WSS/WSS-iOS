//
//  FeedViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import Foundation

import RxSwift
import RxCocoa

final class FeedViewModel: ViewModelType {
    
    //MARK: - Properties

    private let gender = UserDefaults.standard.string(forKey: StringLiterals.UserDefault.userGender)
    
    //MARK: - Life Cycle
    
    struct Input {
        let pageBarTapped: ControlEvent<IndexPath>
        let createFeedButtonDidTap: ControlEvent<Void>
        let feedEditedNotification: Observable<Notification>
        let blockUserNotification: Observable<Notification>
        let unknownUserNotification: Observable<Notification>
    }
    
    struct Output {
        let categoryList = BehaviorRelay<[NewNovelGenre]>(value: [])
        let selectedTabIndex = PublishSubject<Int>()
        let pushToFeedEditViewController = PublishRelay<Void>()
        let showFeedEditedToast =  PublishRelay<Void>()
        let showBlockUserToast =  PublishRelay<String>()
        let showUnknownUserToast =  PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        output.categoryList.accept(gender == "M"
                                   ? NewNovelGenre.feedMaleGenres
                                   : NewNovelGenre.feedFemaleGenres)
        
        input.pageBarTapped
            .map{$0.row}
            .bind(to: output.selectedTabIndex)
            .disposed(by: disposeBag)
        
        input.createFeedButtonDidTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                AmplitudeManager.shared.track(AmplitudeEvent.Feed.feedWriteFloatingButton)
                output.pushToFeedEditViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.feedEditedNotification
            .subscribe(with: self, onNext: { owner, _ in
                output.showFeedEditedToast.accept(())
            })
            .disposed(by: disposeBag)
        
        input.blockUserNotification
            .subscribe(with: self, onNext: { owner, notification in
                guard let nickname = notification.object as? String else { return }
                output.showBlockUserToast.accept(nickname)
            })
            .disposed(by: disposeBag)
        
        input.unknownUserNotification
            .subscribe(with: self, onNext: { owner, notification in
                output.showUnknownUserToast.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
