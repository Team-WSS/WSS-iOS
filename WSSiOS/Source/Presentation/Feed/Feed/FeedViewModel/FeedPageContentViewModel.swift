//
//  FeedPageContentViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 9/28/24.
//

import UIKit

import RxSwift
import RxCocoa

final class FeedPageContentViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let feedRepository: FeedRepository
    private let feedDetailRepository: FeedDetailRepository
    private let userInfoRepository: UserInfoRepository
    
    private var isLoadable: Bool = false
    private var isFetching: Bool = false
    private var lastFeedId: Int = 0
    
    private var feedId: Int = 0
    private var isMyFeed: Bool = false
    
    // output
    private var feedPageType = BehaviorRelay<FeedPageType>(value: .my)
    let filterOption = BehaviorRelay<FeedFilterOption>(value: FeedFilterOption())
    private let sortType = BehaviorRelay<SortType>(value: .newest)
    private let feedTableViewIsRefreshing = PublishRelay<Void>()
    
    private let feedList = BehaviorRelay<[TotalFeedEntity]>(value: [])
    private let myFeedCount = BehaviorRelay<Int>(value: 0)
    private let pushToFeedDetailViewController = PublishRelay<Int>()
    private let pushToUserViewController = PublishRelay<Int>()
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let showDropdownView = PublishRelay<(IndexPath, Bool)>()
    private let hideDropdownView = PublishRelay<Void>()
    private let toggleDropdownView = PublishRelay<Void>()
    private let showSpoilerAlertView = PublishRelay<((Int) -> Observable<Void>, Int)>()
    private let showImproperAlertView = PublishRelay<((Int) -> Observable<Void>, Int)>()
    private let pushToFeedEditViewController = PublishRelay<Int>()
    private let showDeleteAlertView = PublishRelay<((Int) -> Observable<Void>, Int)>()
    private let feedTableViewEndRefreshing = PublishRelay<Void>()
    private let showWithdrawalUserToastView = PublishRelay<Void>()
    
    //MARK: - Life Cycle
    
    init(feedRepository: FeedRepository, feedDetailRepository: FeedDetailRepository, userInfoRepository: UserInfoRepository, feedPageType: FeedPageType) {
        self.feedRepository = feedRepository
        self.feedDetailRepository = feedDetailRepository
        self.userInfoRepository = userInfoRepository
        self.feedPageType.accept(feedPageType)
    }
    
    struct Input {
        let reloadFeed: Observable<Void>
        let sortButtonDidTap: ControlEvent<Void>
        let feedTableViewItemSelected: Observable<IndexPath>
        let feedProfileViewDidTap: Observable<Int>
        let feedDropdownButtonDidTap: Observable<(Int, Bool)>
        let dropdownButtonDidTap: Observable<DropdownButtonType>
        let feedConnectedNovelViewDidTap: Observable<Int>
        let feedLikeViewDidTap: Observable<(Int, Bool)>
        let feedTableViewVillBeginDragging: Observable<Void>
        let feedTableViewReachedBottom: Observable<Bool>
        let feedTableViewIsRefreshing: Observable<Void>
    }
    
    struct Output {
        let feedPageType: Driver<FeedPageType>
        let myFeedCount: Driver<Int>
        let sortType: Driver<SortType>
        let feedList: Observable<[TotalFeedEntity]>
        let pushToFeedDetailViewController: Observable<Int>
        let pushToUserViewController: Observable<Int>
        let pushToNovelDetailViewController: Observable<Int>
        let showDropdownView: Observable<(IndexPath, Bool)>
        let hideDropdownView: Observable<Void>
        let toggleDropdownView: Observable<Void>
        let showSpoilerAlertView: Observable<((Int) -> Observable<Void>, Int)>
        let showImproperAlertView: Observable<((Int) -> Observable<Void>, Int)>
        let pushToFeedEditViewController: Observable<Int>
        let showDeleteAlertView: Observable<((Int) -> Observable<Void>, Int)>
        let feedTableViewEndRefreshing: Observable<Void>
        let showWithdrawalUserToastView: Observable<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.reloadFeed
            .do(onNext: { _ in
                self.isLoadable = false
                self.lastFeedId = 0
            })
            .withLatestFrom(feedList)
            .flatMapLatest { feedList in
                self.getFeedData(lastFeedId: self.lastFeedId,
                                 size: feedList.isEmpty ? nil : feedList.count)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.isLoadable = data.isLoadable
                if let lastFeed = data.feeds.last {
                    owner.lastFeedId = lastFeed.feedId
                }
                owner.feedList.accept(data.feeds)
            }, onError: { owner, error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        input.sortButtonDidTap
            .withLatestFrom(sortType)
            .map { $0.toggle() }
            .bind(to: sortType)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(filterOption, sortType)
            .subscribe(with: self, onNext: { owner, query in
                owner.feedTableViewIsRefreshing.accept(())
                
            })
            .disposed(by: disposeBag)
        
        input.feedTableViewItemSelected
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.pushToFeedDetailViewController.accept(owner.feedList.value[indexPath.item].feedId)
                owner.hideDropdownView.accept(())
            })
            .disposed(by: disposeBag)
        
        input.feedProfileViewDidTap
            .subscribe(with: self, onNext: { owner, userId in
                let myUserId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
                guard myUserId != userId else { return }
                
                if userId == -1 {
                    owner.showWithdrawalUserToastView.accept(())
                } else {
                    owner.pushToUserViewController.accept(userId)
                }
                owner.hideDropdownView.accept(())
            })
            .disposed(by: disposeBag)
        
        input.feedConnectedNovelViewDidTap
            .subscribe(with: self, onNext: { owner, novelId in
                owner.pushToNovelDetailViewController.accept(novelId)
                owner.hideDropdownView.accept(())
            })
            .disposed(by: disposeBag)
        
        input.feedDropdownButtonDidTap
            .subscribe(with: self, onNext: { owner, data in
                let (feedId, isMyFeed) = data
                if owner.feedId == feedId {
                    owner.toggleDropdownView.accept(())
                } else {
                    if let index = owner.feedList.value.firstIndex(where: { $0.feedId == feedId }) {
                        let indexPath = IndexPath(row: index, section: 0)
                        owner.showDropdownView.accept((indexPath, isMyFeed))
                    }
                }
                owner.feedId = feedId
                owner.isMyFeed = isMyFeed
            })
            .disposed(by: disposeBag)
        
        input.dropdownButtonDidTap
            .map { ($0, self.isMyFeed) }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe( with: self, onNext: { owner, result in
                owner.hideDropdownView.accept(())
                switch result {
                case (.top, true): owner.pushToFeedEditViewController.accept(owner.feedId)
                    owner.hideDropdownView.accept(())
                case (.bottom, true): owner.showDeleteAlertView.accept((owner.deleteFeed, owner.feedId))
                case (.top, false): owner.showSpoilerAlertView.accept((owner.postSpoilerFeed, owner.feedId))
                case (.bottom, false): owner.showImproperAlertView.accept((owner.postImpertinenceFeed, owner.feedId))
                }
            })
            .disposed(by: disposeBag)
        
        input.feedLikeViewDidTap
            .flatMapLatest { data -> Observable<(feedId: Int, isLiked: Bool)> in
                let (feedId, isLiked) = data
                
                // 1. UI 반영
                var updatedFeeds = self.feedList.value
                if let index = updatedFeeds.firstIndex(where: { $0.feedId == feedId }) {
                    updatedFeeds[index].isLiked.toggle()
                    let value = updatedFeeds[index].isLiked ? 1 : -1
                    updatedFeeds[index].likeCount += value
                    HapticManager.shared.generateImpactFeedback(style: .light)
                    self.feedList.accept(updatedFeeds)
                }
                
                // 2. 서버 api 호출
                let request: Observable<Void> = isLiked
                ? self.deleteFeedLike(feedId)
                : self.postFeedLike(feedId)
                    .do(onNext: {
                        AmplitudeManager.shared.track(AmplitudeEvent.Feed.feedLike)
                    })
                
                // 3. 요청 실패 시 롤백
                return request
                    .map { (feedId, isLiked) }
                    .catch { error in
                        var rollbackFeeds = self.feedList.value
                        if let index = rollbackFeeds.firstIndex(where: { $0.feedId == feedId }) {
                            rollbackFeeds[index].isLiked = isLiked
                            let delta = isLiked ? 1 : -1
                            rollbackFeeds[index].likeCount += delta
                            self.feedList.accept(rollbackFeeds)
                        }
                        return .empty()
                    }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        input.feedTableViewVillBeginDragging
            .subscribe(with: self, onNext: { owner, _ in
                owner.hideDropdownView.accept(())
            })
            .disposed(by: disposeBag)
        
        input.feedTableViewReachedBottom
            .filter { reachedBottom in
                return reachedBottom && !self.isFetching && self.isLoadable
            }
            .do(onNext: { _ in
                self.isFetching = true
            })
            .flatMapLatest {_ in
                self.getFeedData(lastFeedId: self.lastFeedId,
                                 size: nil)
                .do(onNext: { _ in
                    self.isFetching = false
                })
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.isLoadable = data.isLoadable
                if let lastFeed = data.feeds.last {
                    owner.lastFeedId = lastFeed.feedId
                }
                let newData = owner.feedList.value + data.feeds
                owner.feedList.accept(newData)
            }, onError: { owner, error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        input.feedTableViewIsRefreshing
            .bind(to: feedTableViewIsRefreshing)
            .disposed(by: disposeBag)
        
        self.feedTableViewIsRefreshing
            .do(onNext: { _ in
                self.isLoadable = false
                self.lastFeedId = 0
            })
            .flatMapLatest { _ in
                self.getFeedData(lastFeedId: self.lastFeedId,
                                 size: nil)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.isLoadable = data.isLoadable
                if let lastFeed = data.feeds.last {
                    owner.lastFeedId = lastFeed.feedId
                }
                owner.feedList.accept(data.feeds)
                owner.feedTableViewEndRefreshing.accept(())
            }, onError: { owner, error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        return Output(
            feedPageType: feedPageType.asDriver(),
            myFeedCount: myFeedCount.asDriver(),
            sortType: sortType.asDriver(),
            feedList: feedList.asObservable(),
            pushToFeedDetailViewController: pushToFeedDetailViewController.asObservable(),
            pushToUserViewController: pushToUserViewController.asObservable(),
            pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
            showDropdownView: showDropdownView.asObservable(),
            hideDropdownView: hideDropdownView.asObservable(),
            toggleDropdownView: toggleDropdownView.asObservable(),
            showSpoilerAlertView: showSpoilerAlertView.asObservable(),
            showImproperAlertView: showImproperAlertView.asObservable(),
            pushToFeedEditViewController: pushToFeedEditViewController.asObservable(),
            showDeleteAlertView: showDeleteAlertView.asObservable(),
            feedTableViewEndRefreshing: feedTableViewEndRefreshing.asObservable(),
            showWithdrawalUserToastView: showWithdrawalUserToastView.asObservable()
        )
    }
    
    //MARK: - API
    
    private func getFeedData(lastFeedId: Int, size: Int?) -> Observable<TotalFeedListEntity> {
        switch feedPageType.value {
        case .my: return self.getMyFeedData(lastFeedId: lastFeedId, size: size)
        case .sosoAll: return self.feedRepository.getFeedData(lastFeedId: lastFeedId, size: size, feedsOption: SosoFeedTab.all.rawValue)
        case.sosoRecommended: return self.feedRepository.getFeedData(lastFeedId: lastFeedId, size: size, feedsOption: SosoFeedTab.recommended.rawValue)
        }
    }
    
    private func getMyFeedData(lastFeedId: Int, size: Int?) -> Observable<TotalFeedListEntity> {
        let profileEntity = userInfoRepository.getMyProfileData()
        let userId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
        let userFeedListEntity = userInfoRepository.getUserFeed(
            userId: userId,
            lastFeedId: lastFeedId,
            size: size ?? 20,
            filterOption: filterOption.value,
            sortType: sortType.value
        )
        
        return Observable.zip(profileEntity, userFeedListEntity)
            .do { [weak self] profile, userFeedListEntity in
                self?.myFeedCount.accept(userFeedListEntity.feedsCount)
            }
            .map { profileEntity, userFeedListEntity in
                TotalFeedListEntity.from(
                    userFeedListEntity: userFeedListEntity,
                    myProfileEntity: profileEntity,
                    userId: userId)
            }
    }
    
    private func postFeedLike(_ feedId: Int) -> Observable<Void> {
        feedDetailRepository.postFeedLike(feedId: feedId)
            .observe(on: MainScheduler.instance)
    }
    
    private func deleteFeedLike(_ feedId: Int) -> Observable<Void> {
        feedDetailRepository.deleteFeedLike(feedId: feedId)
            .observe(on: MainScheduler.instance)
    }
    
    func postSpoilerFeed(_ feedId: Int) -> Observable<Void> {
        feedDetailRepository.postSpoilerFeed(feedId: feedId)
            .observe(on: MainScheduler.instance)
    }
    
    func postImpertinenceFeed(_ feedId: Int) -> Observable<Void> {
        feedDetailRepository.postImpertinenceFeed(feedId: feedId)
            .observe(on: MainScheduler.instance)
    }
    
    func deleteFeed(_ feedId: Int) -> Observable<Void> {
        feedDetailRepository.deleteFeed(feedId: feedId)
            .observe(on: MainScheduler.instance)
    }
}
