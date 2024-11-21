//
//  FeedGenreViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 9/28/24.
//

import UIKit

import RxSwift
import RxCocoa

final class FeedGenreViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let feedRepository: FeedRepository
    private let feedDetailRepository: FeedDetailRepository
    
    private let category: String
    private var isLoadable: Bool = false
    private var isFetching: Bool = false
    private var lastFeedId: Int = 0
    
    private var feedId: Int = 0
    private var isMyFeed: Bool = false
    
    // output
    
    private let feedList = BehaviorRelay<[TotalFeeds]>(value: [])
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
    
    //MARK: - Life Cycle
    
    init(feedRepository: FeedRepository, feedDetailRepository: FeedDetailRepository, category: String) {
        self.feedRepository = feedRepository
        self.feedDetailRepository = feedDetailRepository
        self.category = category
    }
    
    struct Input {
        let reloadFeed: Observable<Void>
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
        let feedList: Observable<[TotalFeeds]>
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
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.reloadFeed
            .do(onNext: { _ in
                self.isLoadable = false
                self.lastFeedId = 0
            })
            .flatMapLatest { _ in
                self.getFeedData(category: self.category,
                                 lastFeedId: self.lastFeedId,
                                 size: self.feedList.value.isEmpty ? nil : self.feedList.value.count)
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
        
        input.feedTableViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.pushToFeedDetailViewController.accept(owner.feedList.value[indexPath.item].feedId)
                owner.hideDropdownView.accept(())
            })
            .disposed(by: disposeBag)
        
        input.feedProfileViewDidTap
            .subscribe(with: self, onNext: { owner, userId in
                owner.pushToUserViewController.accept(userId)
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
                    return self.postFeedLike(feedId)
                }
            }
            .do(onNext: { _ in
                self.isLoadable = false
                self.lastFeedId = 0
            })
            .flatMapLatest { _ in
                self.getFeedData(category: self.category,
                                 lastFeedId: self.lastFeedId,
                                 size: self.feedList.value.isEmpty ? nil : self.feedList.value.count)
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
                self.getFeedData(category: self.category,
                                 lastFeedId: self.lastFeedId,
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
            .do(onNext: { _ in
                self.isLoadable = false
                self.lastFeedId = 0
            })
            .flatMapLatest { _ in
                self.getFeedData(category: self.category,
                                 lastFeedId: self.lastFeedId,
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
            feedTableViewEndRefreshing: feedTableViewEndRefreshing.asObservable()
        )
    }
    
    //MARK: - API
    
    private func getFeedData(category: String, lastFeedId: Int, size: Int?) -> Observable<TotalFeed> {
        return self.feedRepository.getFeedData(category: category, lastFeedId: lastFeedId, size: size)
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

