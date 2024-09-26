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
    private let feedList = PublishSubject<[TotalFeeds]>()
    private let isLoadable: Bool = false
    private let isFetching: Bool = false
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
        let pushTofeedWriteViewController: Observable<[NewNovelGenre]>
        let pushToReviewViewController: Observable<ReadStatus>
        
        //Tab
        let selectedTab: Driver<Tab>
        
        //NovelDetailInfo
        let isInfoDescriptionExpended: Driver<Bool>
        let platformList: Driver<[Platform]>
        let keywordList: Driver<[Keyword]>
        let reviewSectionVisibilities: Driver<[ReviewSectionVisibility]>
        
        //NovelDetailFeed
        let feedList: Observable<[TotalFeeds]>
        let novelDetailFeedTableViewHeight: Observable<CGFloat>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest { _ in
                self.novelDetailRepository.getNovelDetailHeaderData(novelId: self.novelId)
            }
            .subscribe(with: self, onNext: { owner, data in
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
                return selectedReadStatus
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
        
        let pushTofeedWriteViewController = input.feedWriteButtonDidTap.map { _ in self.novelGenre.value }
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
        
//        input.feedTabBarButtonDidTap
//            .bind(with: self, onNext: { owner, _ in
//                owner.selectedTab.accept(.feed)
//            })
//            .disposed(by: disposeBag)
        
        input.stickyInfoTabBarButtonDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.info)
            })
            .disposed(by: disposeBag)
        
//        input.stickyFeedTabBarButtonDidTap
//            .bind(with: self, onNext: { owner, _ in
//                owner.selectedTab.accept(.feed)
//            })
//            .disposed(by: disposeBag)
        
        Observable.merge(
            input.feedTabBarButtonDidTap.asObservable(),
            input.stickyFeedTabBarButtonDidTap.asObservable()
        )
        .do(onNext: {
            self.selectedTab.accept(.feed)
        })
        .flatMapLatest {
            self.getNovelDetailFeedData(novelId: 1, lastFeedId: 0)
        }
        .subscribe(with: self, onNext: { owner, data in
            owner.feedList.onNext(data.feeds)
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
            .subscribe(with: self, onNext: { owner, bottom in
                print("novelDetailFeedTableViewReachedBottom", bottom)
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
            novelDetailFeedTableViewHeight: novelDetailFeedTableViewHeight.asObservable()
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
