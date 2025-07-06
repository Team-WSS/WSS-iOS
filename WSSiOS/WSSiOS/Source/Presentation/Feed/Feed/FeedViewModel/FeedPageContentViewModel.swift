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
    
    private var isLoadable: Bool = false
    private var isFetching: Bool = false
    private var lastFeedId: Int = 0
    private var feedsOption: String = SosoFeedTab.all.rawValue
    
    private var feedId: Int = 0
    private var isMyFeed: Bool = false
    
    // output
    private var feedPageType = BehaviorRelay<FeedPageType>(value: .my)
    private let filterOption = PublishRelay<FeedFilterOption>()
    private let sortType = BehaviorRelay<SortType>(value: .newest)
    
    private let feedList = BehaviorRelay<[TotalFeedEntity]>(value: [])
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
    
    init(feedRepository: FeedRepository, feedDetailRepository: FeedDetailRepository, feedPageType: FeedPageType) {
        self.feedRepository = feedRepository
        self.feedDetailRepository = feedDetailRepository
        self.feedPageType.accept(feedPageType)
    }
    
    struct Input {
        let reloadFeed: Observable<Void>
        let feedFilterOptionDidChanged: Observable<FeedFilterOption>
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
            .flatMapLatest { _ in
                self.getFeedData(lastFeedId: self.lastFeedId,
                                 size: self.feedList.value.isEmpty ? nil : self.feedList.value.count,
                                 feedsOption: self.feedsOption)
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
        
        input.feedFilterOptionDidChanged
            .bind(to: filterOption)
            .disposed(by: disposeBag)
        
        input.sortButtonDidTap
            .withLatestFrom(sortType)
            .map { $0.toggle() }
            .bind(to: sortType)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(filterOption, sortType)
            .subscribe(with: self, onNext: { owner, query in
                // Todo Reload FeedData with filter&sort query
                
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
            .flatMapLatest { data in
                let (feedId, isLiked) = data
                if isLiked {
                    return self.deleteFeedLike(feedId)
                } else {
                    AmplitudeManager.shared.track(AmplitudeEvent.Feed.feedLike)
                    return self.postFeedLike(feedId)
                }
            }
            .do(onNext: { _ in
                self.isLoadable = false
                self.lastFeedId = 0
            })
            .flatMapLatest { _ in
                self.getFeedData(lastFeedId: self.lastFeedId,
                                 size: self.feedList.value.isEmpty ? nil : self.feedList.value.count,
                                 feedsOption: self.feedsOption)
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
                                 size: nil,
                                 feedsOption: self.feedsOption)
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
            .do(onNext: { _ in
                self.isLoadable = false
                self.lastFeedId = 0
            })
            .flatMapLatest { _ in
                self.getFeedData(lastFeedId: self.lastFeedId,
                                 size: nil,
                                 feedsOption: self.feedsOption)
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
    
    private func getFeedData(lastFeedId: Int, size: Int?, feedsOption: String) -> Observable<TotalFeedListEntity> {
        return self.feedRepository.getFeedData(lastFeedId: lastFeedId, size: size, feedsOption: feedsOption)
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
