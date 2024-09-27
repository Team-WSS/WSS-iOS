//
//  NovelDetailViewModel.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import Foundation

import RxSwift
import RxCocoa
import Then

final class NovelDetailViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let novelDetailRepository: NovelDetailRepository
    private let novelId: Int
    private var novelTitle: String = ""
    
    //Total
    private let viewWillAppearEvent = BehaviorRelay<Bool>(value: false)
    
    //NovelDetailHeader
    private let novelDetailHeaderData = PublishSubject<NovelDetailHeaderEntity>()
    private let showLargeNovelCoverImage = BehaviorRelay<Bool>(value: false)
    private let isUserNovelInterested = BehaviorRelay<Bool>(value: false)
    private let readStatus = BehaviorRelay<ReadStatus?>(value: nil)
    private let novelGenre = BehaviorRelay<[NewNovelGenre]>(value: [])
    
    //Tab
    private let selectedTab = BehaviorRelay<Tab>(value: Tab.info)
    
    //NovelDetailInfo
    private let novelDetailInfoData = PublishSubject<NovelDetailInfoResult>()
    private let isInfoDescriptionExpended = BehaviorRelay<Bool>(value: false)
    private let platformList = BehaviorRelay<[Platform]>(value: [])
    private let keywordList = BehaviorRelay<[Keyword]>(value: [])
    private let reviewSectionVisibilities = BehaviorRelay<[ReviewSectionVisibility]>(value: [])
    
    //NovelDetailFeed
    private var isLoadable: Bool = false
    private var isFetching: Bool = false
    private var lastFeedId: Int = 0
    private let feedList = BehaviorRelay<[NovelDetailFeed]>(value: [])
    private let novelDetailFeedTableViewHeight = PublishRelay<CGFloat>()
    
    //MARK: - Life Cycle
    
    init(novelDetailRepository: NovelDetailRepository, novelId: Int = 0) {
        self.novelDetailRepository = novelDetailRepository
        self.novelId = novelId
    }
    
    //MARK: - Transform
    
    struct Input {
        //Total
        let viewWillAppearEvent: Observable<Bool>
        let scrollContentOffset: ControlProperty<CGPoint>
        let backButtonDidTap: ControlEvent<Void>
        
        //NovelDetailHeader
        let novelCoverImageButtonDidTap: ControlEvent<Void>
        let largeNovelCoverImageDismissButtonDidTap: ControlEvent<Void>
        let largeNovelCoverImageBackgroundDidTap: ControlEvent<Void>
        let reviewResultButtonDidTap: Observable<ReadStatus?>
        let interestButtonDidTap: ControlEvent<Void>
        let feedWriteButtonDidTap: ControlEvent<Void>
        
        //Tab
        let infoTabBarButtonDidTap: ControlEvent<Void>
        let feedTabBarButtonDidTap: ControlEvent<Void>
        let stickyInfoTabBarButtonDidTap: ControlEvent<Void>
        let stickyFeedTabBarButtonDidTap: ControlEvent<Void>
        
        //NovelDetailInfo
        let descriptionAccordionButtonDidTap: ControlEvent<Void>
        
        //NovelDetailFeed
        let novelDetailFeedTableViewContentSize: Observable<CGSize?>
        let scrollViewReachedBottom: Observable<Bool>
        let createFeedButtonDidTap: ControlEvent<Void>
        
        //NovelReview
        let novelReviewedNotification: Observable<Notification>
    }
    
    struct Output {
        //Total
        let detailHeaderData: Observable<NovelDetailHeaderEntity>
        let detailInfoData: Observable<NovelDetailInfoResult>
        let scrollContentOffset: ControlProperty<CGPoint>
        let popToLastViewController: Observable<Void>
        
        //NovelDetailHeader
        let showLargeNovelCoverImage: Driver<Bool>
        let isUserNovelInterested: Driver<Bool>
        let pushTofeedWriteViewController: Observable<(genre: [NewNovelGenre], novelId: Int, novelTitle: String)>
        let pushToReviewViewController: Observable<(readStatus: ReadStatus, novelId: Int, novelTitle: String)>
        
        //Tab
        let selectedTab: Driver<Tab>
        
        //NovelDetailInfo
        let isInfoDescriptionExpended: Driver<Bool>
        let platformList: Driver<[Platform]>
        let keywordList: Driver<[Keyword]>
        let reviewSectionVisibilities: Driver<[ReviewSectionVisibility]>
        
        //NovelDetailFeed
        let feedList: Observable<[NovelDetailFeed]>
        let novelDetailFeedTableViewHeight: Observable<CGFloat>
        
        //NovelReview
        let showNovelReviewedToast: Observable<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest { _ in
                self.novelDetailRepository.getNovelDetailHeaderData(novelId: self.novelId)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.novelTitle = data.novelTitle
                owner.novelDetailHeaderData.onNext(data)
                owner.isUserNovelInterested.accept(data.isUserNovelInterest)
                owner.readStatus.accept(data.readStatus)
                
                owner.novelGenre.accept(data.novelGenre.split{ $0 == "/"}
                    .map{ String($0) }
                    .map { NewNovelGenre.withKoreanRawValue(from: $0) })
            }, onError: { owner, error in
                owner.novelDetailHeaderData.onError(error)
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .flatMapLatest { _ in
                self.novelDetailRepository.getNovelDetailInfoData(novelId: self.novelId)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.novelDetailInfoData.onNext(data)
                owner.platformList.accept(data.platforms)
                owner.keywordList.accept(data.keywords)
            }, onError: { owner, error in
                owner.novelDetailInfoData.onError(error)
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .do(onNext: { _ in
                self.isLoadable = false
                self.lastFeedId = 0
            })
            .flatMapLatest { _ in
                self.getNovelDetailFeedData(novelId: self.novelId, lastFeedId: self.lastFeedId)
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
                let selectedReadStatus = $0 ?? self.readStatus.value
                guard let selectedReadStatus else { throw RxError.noElements }
                return (readStatus: selectedReadStatus,
                        novelId: self.novelId,
                        novelTitle: self.novelTitle)
            }
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .asObservable()
        
        input.interestButtonDidTap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
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
            })
            .disposed(by: disposeBag)
        
        let pushTofeedWriteViewController = Observable.merge(
            input.feedWriteButtonDidTap.asObservable(),
            input.createFeedButtonDidTap.asObservable()
        )
        .map { _ in
            (genre: self.novelGenre.value,
             novelId: self.novelId,
             novelTitle: self.novelTitle)
        }
        .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
        .asObservable()
        
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
            self.getNovelDetailFeedData(novelId: self.novelId, lastFeedId: self.lastFeedId)
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
        
        input.scrollViewReachedBottom
            .filter { reachedBottom in
                return reachedBottom && !self.isFetching && self.isLoadable
            }
            .do(onNext: { _ in
                self.isFetching = true
            })
            .flatMapLatest {_ in 
                self.getNovelDetailFeedData(novelId: self.novelId, lastFeedId: self.lastFeedId)
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
        
        let showNovelReviewedToast = input.novelReviewedNotification
            .map { _ in () }
            .asObservable()
        
        return Output(
            detailHeaderData: novelDetailHeaderData.asObservable(),
            detailInfoData: novelDetailInfoData.asObserver(),
            scrollContentOffset: scrollContentOffset,
            popToLastViewController: backButtonDidTap,
            showLargeNovelCoverImage: showLargeNovelCoverImage.asDriver(),
            isUserNovelInterested: isUserNovelInterested.asDriver(),
            pushTofeedWriteViewController: pushTofeedWriteViewController,
            pushToReviewViewController: pushToReviewViewController,
            selectedTab: selectedTab.asDriver(),
            isInfoDescriptionExpended: isInfoDescriptionExpended.asDriver(),
            platformList: platformList.asDriver(),
            keywordList: keywordList.asDriver(),
            reviewSectionVisibilities: reviewSectionVisibilities.asDriver(),
            feedList: feedList.asObservable(),
            novelDetailFeedTableViewHeight: novelDetailFeedTableViewHeight.asObservable(),
            showNovelReviewedToast: showNovelReviewedToast
        )
    }
    
    //MARK: - API
    
    private func getNovelDetailFeedData(novelId: Int, lastFeedId: Int) -> Observable<NovelDetailFeedResult> {
        novelDetailRepository.getNovelDetailFeedData(novelId: novelId, lastFeedId: lastFeedId)
            .observe(on: MainScheduler.instance)
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
