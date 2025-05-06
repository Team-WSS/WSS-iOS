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
    
    //init
    private let userRepository: UserInfoRepository
    private let profileData: MyProfileEntity
    private let profileId: Int
    
    //피드 정보 관련 데이터
    private let isMyPage = PublishRelay<Bool>()
    private var feedId: Int = 0
    private var isMyFeed: Bool = false
    
    //무한스크롤 기능
    private let feedDataRelay = BehaviorRelay<[MyFeedListItem]>(value: [])
    private let isLoadableRelay = BehaviorRelay<Bool>(value: true)
    private let lastFeedIdRelay = BehaviorRelay<Int>(value: 0)
    private var isFetching = false
    
    //Action Relay
    private let showLoadingViewRelay = BehaviorRelay<Bool>(value: false)
    private let pushToFeedDetailViewController = PublishRelay<Int>()
    
    
    //MARK: - Life Cycle
    
    init(userRepository: UserInfoRepository, profileId: Int, profileData: MyProfileEntity) {
        self.userRepository = userRepository
        
        self.profileId = profileId
        self.profileData = profileData
    }
    
    struct Input {
        let loadNextPageTrigger: Observable<Void>
        let viewWillAppearEvent: Observable<Void>
        let feedTableViewItemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let bindFeedData: BehaviorRelay<[MyFeedListItem]>
        let isMyPage: PublishRelay<Bool>
        let pushToFeedDetailViewController: Observable<Int>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.loadNextPageTrigger
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return !self.isFetching && self.isLoadableRelay.value
            }
            .do(onNext: { [weak self] _ in
                self?.isFetching = true
            })
            .flatMapLatest { [weak self] _ -> Observable<MyFeedListEntity> in
                guard let self = self else { return .empty() }
                return self.getUserFeed(userId: self.profileId,
                                        lastFeedId: self.lastFeedIdRelay.value,
                                        size: 20)
            }
            .subscribe(onNext: { [weak self] feedResult in
                self?.updateFeedList(feedResult)
            }, onError: { [weak self] error in
                self?.isFetching = false
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        input.viewWillAppearEvent
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
                self.isMyPage.accept(userId == self.profileId)
                
                self.feedDataRelay.accept([])
                self.lastFeedIdRelay.accept(0)
                self.isLoadableRelay.accept(true)
                self.isFetching = true
            })
            .flatMapLatest { [weak self] _ -> Observable<MyFeedListEntity> in
                guard let self = self else { return .empty() }
                return self.getUserFeed(userId: self.profileId,
                                        lastFeedId: 0,
                                        size: 20)
            }
            .subscribe(onNext: { [weak self] feedResult in
                self?.updateFeedList(feedResult)
            }, onError: { [weak self] error in
                self?.isFetching = false
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.feedTableViewItemSelected
            .bind(with: self, onNext: { owner, indexPath in
                let feedId = self.feedDataRelay.value[indexPath.row].feed.feedId
                self.pushToFeedDetailViewController.accept(feedId)
            })
            .disposed(by: disposeBag)
        
        return Output(bindFeedData: self.feedDataRelay,
                      isMyPage: self.isMyPage,
                      pushToFeedDetailViewController: self.pushToFeedDetailViewController.asObservable())
    }
    
    private func updateFeedList(_ feedResult: MyFeedListEntity) {
        let newFeedData = feedResult.feeds
            .map { feed in
                MyFeedListItem(feed: feed,
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
    
    private func getUserFeed(userId: Int, lastFeedId: Int, size: Int) -> Observable<MyFeedListEntity> {
        return userRepository.getUserFeed(userId: userId, lastFeedId: lastFeedId, size: size)
    }
}
