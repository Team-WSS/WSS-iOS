//
//  MyPageFeedDetailViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 12/3/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageFeedDetailViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let userRepository: UserRepository
    private let profileData: MyProfileResult
    private let profileId: Int
    
    private let feedDataRelay = BehaviorRelay<[FeedCellData]>(value: [])
    private let isLoadableRelay = BehaviorRelay<Bool>(value: true)
    private let lastFeedIdRelay = BehaviorRelay<Int>(value: 0)
    
    private let showLoadingViewRelay = BehaviorRelay<Bool>(value: false)
    private let popViewControllerRelay = PublishRelay<Void>()
    private let isMyPage = PublishRelay<Bool>()
    
    private var isFetching = false
    
    
    //MARK: - Life Cycle
    
    init(userRepository: UserRepository, profileId: Int, profileData: MyProfileResult) {
        self.userRepository = userRepository
        self.profileId = profileId
        self.profileData = profileData
    }
    
    struct Input {
        let loadNextPageTrigger: Observable<Void>
        let popViewController: ControlEvent<Void>
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let bindFeedData: BehaviorRelay<[FeedCellData]>
        let popViewController: PublishRelay<Void>
        let isMyPage: PublishRelay<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.loadNextPageTrigger
            .filter { [unowned self] _ in !self.isFetching && self.isLoadableRelay.value }
            .do(onNext: { [unowned self] _ in self.isFetching = true })
            .flatMapLatest { [unowned self] _ in
                self.getUserFeed(userId: self.profileId,
                                 lastFeedId: self.lastFeedIdRelay.value,
                                 size: 20)
            }
            .subscribe(with: self, onNext: { owner, feedResult in
                owner.updateFeedList(feedResult)
            }, onError: { owner, error in
                owner.isFetching = false
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.popViewController
            .bind(to: self.popViewControllerRelay)
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .bind(with: self, onNext: { owner, _ in
                let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
                owner.isMyPage.accept(userId == self.profileId)
            })
            .disposed(by: disposeBag)
        
        return Output(bindFeedData: self.feedDataRelay,
                      popViewController: self.popViewControllerRelay,
                      isMyPage: self.isMyPage
        )
    }
    
    private func updateFeedList(_ feedResult: MyFeedResult) {
        let newFeedData = feedResult.feeds
            .map { feed in
                FeedCellData(feed: feed,
                             avatarImage: self.profileData.avatarImage,
                             nickname: self.profileData.nickname)
            }
        
        if let lastFeed = feedResult.feeds.last {
            self.lastFeedIdRelay.accept(lastFeed.feedId)
        }
        
        self.feedDataRelay.accept(self.feedDataRelay.value + newFeedData)
        self.isLoadableRelay.accept(feedResult.isLoadable)
        self.isFetching = false
    }
    
    //MARK: - API
    
    private func getUserFeed(userId: Int, lastFeedId: Int, size: Int) -> Observable<MyFeedResult> {
        return userRepository.getUserFeed(userId: userId, lastFeedId: lastFeedId, size: size)
            .asObservable()
    }
}

