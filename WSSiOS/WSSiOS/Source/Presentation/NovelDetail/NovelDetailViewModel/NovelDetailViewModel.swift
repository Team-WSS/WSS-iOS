//
//  NovelDetailViewModel.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import Then

final class NovelDetailViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let novelDetailRepository: NovelDetailRepository
    private let feedDetailRepository: FeedDetailRepository
    
    private let novelId: Int
    private var novelTitle: String = ""
    
    // Total
    private let reloadData = PublishRelay<Void>()
    private let showNetworkErrorView = BehaviorRelay<Bool>(value: false)
    private let showHeaderDropdownView = BehaviorRelay<Bool>(value: false)
    private let showReportPage = PublishRelay<Void>()
    private let showReviewDeleteAlert = PublishRelay<Void>()
    private let showReviewDeletedToast = PublishRelay<Void>()
    private let hideFirstReviewDescription = BehaviorRelay<Bool>(value: false)
    
    // NovelDetailHeader
    private let novelDetailHeaderData = PublishSubject<NovelDetailHeaderEntity>()
    private let showLargeNovelCoverImage = BehaviorRelay<Bool>(value: false)
    private let isUserNovelInterested = BehaviorRelay<Bool>(value: false)
    private let readStatus = BehaviorRelay<ReadStatus?>(value: nil)
    private let novelGenre = BehaviorRelay<[NewNovelGenre]>(value: [])
    
    // Tab
    private let selectedTab = BehaviorRelay<Tab>(value: Tab.info)
    
    // NovelDetailInfo
    private let novelDetailInfoData = PublishSubject<NovelDetailInfoResult>()
    private let isInfoDescriptionExpended = BehaviorRelay<Bool>(value: false)
    private let platformList = BehaviorRelay<[Platform]>(value: [])
    private let keywordList = BehaviorRelay<[Keyword]>(value: [])
    private let reviewSectionVisibilities = BehaviorRelay<[ReviewSectionVisibility]>(value: [])
    
    // NovelDetailFeed
    private var isLoadable: Bool = false
    private var isFetching: Bool = false
    private var lastFeedId: Int = 0
    private let feedList = BehaviorRelay<[TotalFeeds]>(value: [])
    private let novelDetailFeedTableViewHeight = PublishRelay<CGFloat>()
    private let pushToFeedDetailViewController = PublishRelay<Int>()
    private let showDropdownView = PublishRelay<(IndexPath, Bool)>()
    private let hideDropdownView = PublishRelay<Void>()
    private let toggleDropdownView = PublishRelay<Void>()
    private let showSpoilerAlertView = PublishRelay<((Int) -> Observable<Void>, Int)>()
    private let showImproperAlertView = PublishRelay<((Int) -> Observable<Void>, Int)>()
    private let pushToFeedEditViewController = PublishRelay<Int>()
    private let showDeleteAlertView = PublishRelay<((Int) -> Observable<Void>, Int)>()
    private var feedId: Int = 0
    private var isMyFeed: Bool = false
    private let pushToUserViewController = PublishRelay<Int>()
    private let showWithdrawalUserToastView = PublishRelay<Void>()
    
    //MARK: - Life Cycle
    
    init(novelDetailRepository: NovelDetailRepository, feedDetailRepository: FeedDetailRepository, novelId: Int = 0) {
        self.novelDetailRepository = novelDetailRepository
        self.feedDetailRepository = feedDetailRepository
        self.novelId = novelId
    }
    
    //MARK: - Transform
    
    struct Input {
        // Total
        let viewWillAppearEvent: Observable<Void>
        let scrollContentOffset: ControlProperty<CGPoint>
        let backButtonDidTap: ControlEvent<Void>
        let networkErrorRefreshButtonDidTap: ControlEvent<Void>
        let imageNetworkError: Observable<Bool>
        let deleteReview: Observable<Void>
        let backgroundDidTap: ControlEvent<UITapGestureRecognizer>
        let firstDescriptionBackgroundDidTap: ControlEvent<Void>
        
        // NovelDetailHeader
        let headerDotsButtonDidTap: ControlEvent<Void>
        let headerDropdownButtonDidTap: Observable<DropdownButtonType>
        let novelCoverImageButtonDidTap: ControlEvent<Void>
        let largeNovelCoverImageDismissButtonDidTap: ControlEvent<Void>
        let largeNovelCoverImageBackgroundDidTap: ControlEvent<Void>
        let reviewResultButtonDidTap: Observable<ReadStatus?>
        let interestButtonDidTap: ControlEvent<Void>
        let feedWriteButtonDidTap: ControlEvent<Void>
        
        // Tab
        let infoTabBarButtonDidTap: ControlEvent<Void>
        let feedTabBarButtonDidTap: ControlEvent<Void>
        let stickyInfoTabBarButtonDidTap: ControlEvent<Void>
        let stickyFeedTabBarButtonDidTap: ControlEvent<Void>
        
        // NovelDetailInfo
        let descriptionAccordionButtonDidTap: ControlEvent<Void>
        
        // NovelDetailFeed
        let novelDetailFeedTableViewContentSize: Observable<CGSize?>
        let novelDetailFeedTableViewItemSelected: Observable<IndexPath>
        let novelDetailFeedProfileViewDidTap: Observable<Int>
        let novelDetailFeedDropdownButtonDidTap: Observable<(Int, Bool)>
        let dropdownButtonDidTap: Observable<DropdownButtonType>
        let novelDetailFeedConnectedNovelViewDidTap: Observable<Int>
        let novelDetailFeedLikeViewDidTap: Observable<(Int, Bool)>
        let reloadNovelDetailFeed: Observable<Void>
        let scrollViewReachedBottom: Observable<Bool>
        let createFeedButtonDidTap: ControlEvent<Void>
        let feedEditedNotification: Observable<Notification>
        
        // NovelReview
        let novelReviewedNotification: Observable<Notification>
    }
    
    struct Output {
        // Total
        let detailHeaderData: Observable<NovelDetailHeaderEntity>
        let detailInfoData: Observable<NovelDetailInfoResult>
        let scrollContentOffset: ControlProperty<CGPoint>
        let popToLastViewController: Observable<Void>
        let showNetworkErrorView: Driver<Bool>
        let showHeaderDropdownView: Driver<Bool>
        let showReportPage: Driver<Void>
        let showReviewDeleteAlert: Observable<Void>
        let showReviewDeletedToast: Driver<Void>
        let hidefirstReviewDescriptionView: Driver<Bool>
        
        // NovelDetailHeader
        let showLargeNovelCoverImage: Driver<Bool>
        let isUserNovelInterested: Driver<Bool>
        let pushTofeedWriteViewController: Observable<(genre: [NewNovelGenre], novelId: Int, novelTitle: String)>
        let pushToReviewViewController: Observable<(isInterest: Bool, readStatus: ReadStatus, novelId: Int, novelTitle: String)>
        
        // Tab
        let selectedTab: Driver<Tab>
        
        // NovelDetailInfo
        let isInfoDescriptionExpended: Driver<Bool>
        let platformList: Driver<[Platform]>
        let keywordList: Driver<[Keyword]>
        let reviewSectionVisibilities: Driver<[ReviewSectionVisibility]>
        
        // NovelDetailFeed
        let feedList: Observable<[TotalFeeds]>
        let novelDetailFeedTableViewHeight: Observable<CGFloat>
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
        let showFeedEditedToast: Observable<Void>
        let showWithdrawalUserToastView: Observable<Void>
        
        // NovelReview
        let showNovelReviewedToast: Observable<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .bind(to: self.reloadData)
            .disposed(by: disposeBag)
        
        input.firstDescriptionBackgroundDidTap
            .bind(with: self, onNext: { owner, _ in
                UserDefaults.standard.setValue(true,
                                               forKey: StringLiterals.UserDefault.showReviewFirstDescription)
                owner.hideFirstReviewDescription.accept(true)
            })
            .disposed(by: disposeBag)
        
        self.reloadData
            .do(onNext: { _ in
                self.isLoadable = false
                self.lastFeedId = 0
                self.showNetworkErrorView.accept(false)
            })
            .bind(with: self, onNext: { owner, data in
                let isHidden = UserDefaults.standard.bool(forKey: StringLiterals.UserDefault.showReviewFirstDescription)
                owner.hideFirstReviewDescription.accept(isHidden)
                owner.getNovelDetailHeaderData(disposeBag: disposeBag)
                owner.getNovelDetailInfoData(disposeBag: disposeBag)
                owner.getNovelDetailFeedData(disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.imageNetworkError
            .bind(to: self.showNetworkErrorView)
            .disposed(by: disposeBag)
        
        input.networkErrorRefreshButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.reloadData.accept(())
            })
            .disposed(by: disposeBag)
        
        input.headerDotsButtonDidTap
            .withLatestFrom(self.showHeaderDropdownView)
            .map { !$0 }
            .bind(with: self, onNext: { owner, isShow in
                owner.showHeaderDropdownView.accept(isShow)
            })
            .disposed(by: disposeBag)
        
        input.backgroundDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.showHeaderDropdownView.accept(false)
                owner.hideDropdownView.accept(())
            })
            .disposed(by: disposeBag)
        
        input.headerDropdownButtonDidTap
            .bind(with: self, onNext: { owner, type in
                switch type {
                case .top:
                    AmplitudeManager.shared.track(AmplitudeEvent.Novel.contactError)
                    owner.showReportPage.accept(())
                case .bottom:
                    AmplitudeManager.shared.track(AmplitudeEvent.Novel.rateDelete)
                    owner.showReviewDeleteAlert.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.deleteReview
            .bind(with: self, onNext: { owner, type in
                owner.deleteReview(disposeBag: disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.novelCoverImageButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.showLargeNovelCoverImage.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.largeNovelCoverImageDismissButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.showLargeNovelCoverImage.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.largeNovelCoverImageBackgroundDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.showLargeNovelCoverImage.accept(false)
            })
            .disposed(by: disposeBag)
        
        let pushToReviewViewController = input.reviewResultButtonDidTap
            .map {
                AmplitudeManager.shared.track(AmplitudeEvent.Novel.rate)
                let selectedReadStatus = $0 ?? self.readStatus.value
                guard let selectedReadStatus else { throw RxError.noElements }
                return (isInterest: self.isUserNovelInterested.value,
                        readStatus: selectedReadStatus,
                        novelId: self.novelId,
                        novelTitle: self.novelTitle)
            }
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .asObservable()
        
        input.interestButtonDidTap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .do(onNext: { _ in
                AmplitudeManager.shared.track(AmplitudeEvent.Novel.rateLove)
            })
            .withUnretained(isUserNovelInterested)
            .withLatestFrom(isUserNovelInterested)
            .flatMapLatest{ isInterested in
                if isInterested {
                    self.novelDetailRepository.deleteUserInterest(novelId: self.novelId)
                } else {
                    self.novelDetailRepository.postUserInterest(novelId: self.novelId)
                }
            }
            .bind(with: self, onNext: { owner, _ in
                owner.isUserNovelInterested.accept(!owner.isUserNovelInterested.value)
                owner.reloadData.accept(())
            })
            .disposed(by: disposeBag)
        
        let pushToFeedWriteViewControllerFromFeedWriteButton = input.feedWriteButtonDidTap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .do(onNext: {
                AmplitudeManager.shared.track(AmplitudeEvent.Novel.novelWriteButton)
            })
            .map { _ in
                (genre: self.novelGenre.value,
                 novelId: self.novelId,
                 novelTitle: self.novelTitle)
            }

        let pushToFeedWriteViewControllerFromCreateFeedButton = input.createFeedButtonDidTap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .do(onNext: {
                AmplitudeManager.shared.track(AmplitudeEvent.Novel.novelWriteFloatingButton)
            })
            .map { _ in
                (genre: self.novelGenre.value,
                 novelId: self.novelId,
                 novelTitle: self.novelTitle)
            }

        let pushToFeedWriteViewController = Observable.merge(
            pushToFeedWriteViewControllerFromFeedWriteButton,
            pushToFeedWriteViewControllerFromCreateFeedButton
        )
        .do(onNext: { _ in
            self.selectedTab.accept(.feed)
        })
        
        let scrollContentOffset = input.scrollContentOffset
        
        let backButtonDidTap = input.backButtonDidTap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .asObservable()
        
        input.infoTabBarButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.info)
            })
            .disposed(by: disposeBag)
        
        input.stickyInfoTabBarButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.info)
            })
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.feedTabBarButtonDidTap.asObservable(),
            input.stickyFeedTabBarButtonDidTap.asObservable()
        )
        .do(onNext: {
            self.isLoadable = false
            self.lastFeedId = 0
            self.selectedTab.accept(.feed)
        })
        .flatMapLatest { _ in
            self.getNovelDetailFeedData(novelId: self.novelId,
                                        lastFeedId: self.lastFeedId,
                                        size: nil)
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
        
        input.descriptionAccordionButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.isInfoDescriptionExpended.accept(!owner.isInfoDescriptionExpended.value)
            })
            .disposed(by: disposeBag)
        
        input.novelDetailFeedTableViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: self.novelDetailFeedTableViewHeight)
            .disposed(by: disposeBag)
        
        input.novelDetailFeedTableViewItemSelected
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.hideDropdownView.accept(())
                owner.pushToFeedDetailViewController.accept(owner.feedList.value[indexPath.item].feedId)
            })
            .disposed(by: disposeBag)
        
        input.novelDetailFeedDropdownButtonDidTap
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
                case (.bottom, true): owner.showDeleteAlertView.accept((owner.deleteFeed, owner.feedId))
                case (.top, false): owner.showSpoilerAlertView.accept((owner.postSpoilerFeed, owner.feedId))
                case (.bottom, false): owner.showImproperAlertView.accept((owner.postImpertinenceFeed, owner.feedId))
                }
            })
            .disposed(by: disposeBag)
        
        input.novelDetailFeedLikeViewDidTap
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
                self.getNovelDetailFeedData(novelId: self.novelId,
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
        
        input.reloadNovelDetailFeed
            .do(onNext: { _ in
                self.isLoadable = false
                self.lastFeedId = 0
            })
            .flatMapLatest { _ in
                self.getNovelDetailFeedData(novelId: self.novelId,
                                            lastFeedId: self.lastFeedId,
                                            size: nil)
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
        
        input.scrollViewReachedBottom
            .filter { reachedBottom in
                return reachedBottom && !self.isFetching && self.isLoadable
            }
            .do(onNext: { _ in
                self.isFetching = true
            })
            .flatMapLatest {_ in
                self.getNovelDetailFeedData(novelId: self.novelId,
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
        
        self.novelDetailInfoData
            .subscribe(with: self, onNext: { owner, data in
                var visibilities: [ReviewSectionVisibility] = []
                
                if (data.quitCount+data.watchedCount+data.watchingCount) > 0 {
                    visibilities.append(.graph)
                }
                if !data.attractivePoints.isEmpty {
                    visibilities.append(.attractivepoint)
                }
                if !data.keywords.isEmpty {
                    visibilities.append(.keyword)
                }
                
                owner.reviewSectionVisibilities.accept(visibilities)
            }, onError: { owner, error in
                owner.reviewSectionVisibilities.accept([])
            })
            .disposed(by: disposeBag)
        
        let showFeedEditedToast = input.feedEditedNotification
            .map { _ in () }
            .asObservable()
        
        let showNovelReviewedToast = input.novelReviewedNotification
            .map { _ in () }
            .asObservable()
        
        input.novelDetailFeedProfileViewDidTap
            .subscribe(with: self, onNext: { owner, userId in
                if userId == -1 {
                    owner.showWithdrawalUserToastView.accept(())
                } else {
                    owner.pushToUserViewController.accept(userId)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            detailHeaderData: novelDetailHeaderData.asObservable(),
            detailInfoData: novelDetailInfoData.asObserver(),
            scrollContentOffset: scrollContentOffset,
            popToLastViewController: backButtonDidTap,
            showNetworkErrorView: showNetworkErrorView.asDriver(),
            showHeaderDropdownView: showHeaderDropdownView.asDriver(),
            showReportPage: showReportPage.asDriver(onErrorJustReturn: ()),
            showReviewDeleteAlert: showReviewDeleteAlert.asObservable(),
            showReviewDeletedToast: showReviewDeletedToast.asDriver(onErrorJustReturn: ()),
            hidefirstReviewDescriptionView: hideFirstReviewDescription.asDriver(),
            showLargeNovelCoverImage: showLargeNovelCoverImage.asDriver(),
            isUserNovelInterested: isUserNovelInterested.asDriver(),
            pushTofeedWriteViewController: pushToFeedWriteViewController,
            pushToReviewViewController: pushToReviewViewController,
            selectedTab: selectedTab.asDriver(),
            isInfoDescriptionExpended: isInfoDescriptionExpended.asDriver(),
            platformList: platformList.asDriver(),
            keywordList: keywordList.asDriver(),
            reviewSectionVisibilities: reviewSectionVisibilities.asDriver(),
            feedList: feedList.asObservable(),
            novelDetailFeedTableViewHeight: novelDetailFeedTableViewHeight.asObservable(),
            pushToFeedDetailViewController: pushToFeedDetailViewController.asObservable(),
            pushToUserViewController: pushToUserViewController.asObservable(),
            pushToNovelDetailViewController: input.novelDetailFeedConnectedNovelViewDidTap.asObservable(),
            showDropdownView: showDropdownView.asObservable(),
            hideDropdownView: hideDropdownView.asObservable(),
            toggleDropdownView: toggleDropdownView.asObservable(),
            showSpoilerAlertView: showSpoilerAlertView.asObservable(),
            showImproperAlertView: showImproperAlertView.asObservable(),
            pushToFeedEditViewController: pushToFeedEditViewController.asObservable(),
            showDeleteAlertView: showDeleteAlertView.asObservable(),
            showFeedEditedToast: showFeedEditedToast,
            showWithdrawalUserToastView: showWithdrawalUserToastView.asObservable(),
            showNovelReviewedToast: showNovelReviewedToast
        )
    }
    
    //MARK: - API
    
    private func getNovelDetailHeaderData(disposeBag: DisposeBag) {
        self.novelDetailRepository.getNovelDetailHeaderData(novelId: self.novelId)
            .subscribe(with: self, onSuccess: { owner, data in
                owner.novelTitle = data.novelTitle
                owner.novelDetailHeaderData.onNext(data)
                owner.isUserNovelInterested.accept(data.isUserNovelInterest)
                owner.readStatus.accept(data.readStatus)
                
                owner.novelGenre.accept(data.novelGenre.split{ $0 == "/"}
                    .map{ String($0) }
                    .map { NewNovelGenre.withKoreanRawValue(from: $0) })
            }, onFailure: { owner, error in
                owner.showNetworkErrorView.accept(true)
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func getNovelDetailInfoData(disposeBag: DisposeBag) {
        self.novelDetailRepository.getNovelDetailInfoData(novelId: self.novelId)
            .subscribe(with: self, onNext: { owner, data in
                owner.novelDetailInfoData.onNext(data)
                owner.platformList.accept(data.platforms)
                owner.keywordList.accept(data.keywords)
            }, onError: { owner, error in
                owner.showNetworkErrorView.accept(true)
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func getNovelDetailFeedData(disposeBag: DisposeBag) {
        self.isLoadable = false
        self.lastFeedId = 0
        self.getNovelDetailFeedData(novelId: self.novelId,
                                    lastFeedId: self.lastFeedId,
                                    size: self.feedList.value.isEmpty ? nil : self.feedList.value.count)
        .subscribe(with: self, onNext: { owner, data in
            owner.isLoadable = data.isLoadable
            if let lastFeed = data.feeds.last {
                owner.lastFeedId = lastFeed.feedId
            }
            owner.feedList.accept(data.feeds)
        }, onError: { owner, error in
            owner.showNetworkErrorView.accept(true)
            print("Error: \(error)")
        })
        .disposed(by: disposeBag)
    }
    
    private func getNovelDetailFeedData(novelId: Int, lastFeedId: Int, size: Int?) -> Observable<NovelDetailFeedResult> {
        novelDetailRepository.getNovelDetailFeedData(novelId: novelId, lastFeedId: lastFeedId, size: size)
            .observe(on: MainScheduler.instance)
    }
    
    func postFeedLike(_ feedId: Int) -> Observable<Void> {
        feedDetailRepository.postFeedLike(feedId: feedId)
            .observe(on: MainScheduler.instance)
    }
    
    func deleteFeedLike(_ feedId: Int) -> Observable<Void> {
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
    
    func deleteReview(disposeBag: DisposeBag) {
        novelDetailRepository.deleteNovelReview(novelId: self.novelId)
            .subscribe(with: self, onNext: { owner, _ in
                owner.reloadData.accept(())
                owner.showReviewDeletedToast.accept(())
            }, onError: { owner, error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    func keywordNameForItemAt(indexPath: IndexPath) -> String? {
        guard indexPath.item < keywordList.value.count else {
            return nil
        }
        return "\(keywordList.value[indexPath.item].keywordName) \(keywordList.value[indexPath.item].keywordCount)"
    }
}

enum ReviewSectionVisibility {
    case attractivepoint
    case keyword
    case graph
}
