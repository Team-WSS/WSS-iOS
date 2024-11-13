//
//  HomeViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/10/24.
//

import UIKit

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let recommendRepository: RecommendRepository
    private let disposeBag = DisposeBag()
    
    private let isLoggedIn = APIConstants.isLogined
    
    private let todayPopularList = BehaviorRelay<[TodayPopularNovel]>(value: [])
    private let realtimePopularList = PublishSubject<[RealtimePopularFeed]>()
    private let realtimePopularDataRelay = BehaviorRelay<[[RealtimePopularFeed]]>(value: [])
    private let interestList = BehaviorRelay<[InterestFeed]>(value: [])
    private let tasteRecommendList = BehaviorRelay<[TasteRecommendNovel]>(value: [])
    
    let presentInduceLoginViewController = PublishRelay<Void>()
    private let pushToAnnouncementViewController = PublishRelay<Void>()
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let updateInterestView = PublishRelay<(Bool, Bool)>()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let announcementButtonDidTap: ControlEvent<Void>
        let todayPopularCellSelected: ControlEvent<IndexPath>
        let interestCellSelected: ControlEvent<IndexPath>
        let tasteRecommendCellSelected: ControlEvent<IndexPath>
        let tasteRecommendCollectionViewContentSize: Observable<CGSize?>
        
        // 비로그인
        let registerInterestNovelButtonTapped: ControlEvent<Void>
        let setPreferredGenresButtonTapped: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var todayPopularList: Observable<[TodayPopularNovel]>
        var realtimePopularList: Observable<[RealtimePopularFeed]>
        var realtimePopularData: Observable<[[RealtimePopularFeed]]>
        var interestList: Observable<[InterestFeed]>
        var tasteRecommendList: Observable<[TasteRecommendNovel]>
        let pushToAnnouncementViewController: Observable<Void>
        let pushToNovelDetailViewController: Observable<Int>
        let tasteRecommendCollectionViewHeight: Driver<CGFloat>
        let updateInterestView: Observable<(Bool, Bool)>
        
        // 비로그인
        let pushToNormalSearchViewController: Observable<Void>
        let presentInduceLoginViewController: Observable<Void>
    }
    
    //MARK: - init
    
    init(recommendRepository: RecommendRepository) {
        self.recommendRepository = recommendRepository
    }
}

extension HomeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        self.getTodayPopularNovels()
            .subscribe(with: self, onNext: { owner, data in
                owner.todayPopularList.accept(data.popularNovels)
            }, onError: { owner, error in
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .flatMapLatest {
                let realtimeFeedsObservable = self.getRealtimePopularFeeds()
                let interestFeedsObservable = self.isLoggedIn ? self.getInterestFeeds() : Observable.just(InterestFeeds(recommendFeeds: []))
                
                return Observable.zip(realtimeFeedsObservable, interestFeedsObservable)
            }
            .subscribe(with: self, onNext: { owner, data in
                let realtimeFeeds = data.0
                let interestFeeds = data.1
                
                owner.realtimePopularList.onNext(realtimeFeeds.popularFeeds)
                let groupedData = stride(from: 0, to: realtimeFeeds.popularFeeds.count, by: 3)
                    .map { index in
                        Array(realtimeFeeds.popularFeeds[index..<min(index + 3, realtimeFeeds.popularFeeds.count)])
                    }
                owner.realtimePopularDataRelay.accept(groupedData)
                
                if owner.isLoggedIn {
                    owner.interestList.accept(interestFeeds.recommendFeeds)
                    owner.updateInterestView.accept((true, interestFeeds.recommendFeeds.isEmpty))
                } else {
                    owner.updateInterestView.accept((false, true))
                }
            }, onError: { owner, error in
                owner.realtimePopularList.onError(error)
            })
            .disposed(by: disposeBag)
        
        input.setPreferredGenresButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentInduceLoginViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.todayPopularCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                let novelId = owner.todayPopularList.value[indexPath.row].novelId
                owner.pushToNovelDetailViewController.accept(novelId)
            })
            .disposed(by: disposeBag)
        
        input.interestCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                let novelId = owner.interestList.value[indexPath.row].novelId
                owner.pushToNovelDetailViewController.accept(novelId)
            })
            .disposed(by: disposeBag)
        
        input.tasteRecommendCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                let novelId = owner.tasteRecommendList.value[indexPath.row].novelId
                owner.pushToNovelDetailViewController.accept(novelId)
            })
            .disposed(by: disposeBag)
        
        input.announcementButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                if owner.isLoggedIn {
                    owner.pushToAnnouncementViewController.accept(())
                } else {
                    owner.presentInduceLoginViewController.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        let pushToNormalSearchViewController = input.registerInterestNovelButtonTapped.asObservable()
        
        let tasteRecommendCollectionViewHeight = input.tasteRecommendCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        return Output(todayPopularList: todayPopularList.asObservable(),
                      realtimePopularList: realtimePopularList.asObservable(),
                      realtimePopularData: realtimePopularDataRelay.asObservable(),
                      interestList: interestList.asObservable(),
                      tasteRecommendList: tasteRecommendList.asObservable(),
                      pushToAnnouncementViewController: pushToAnnouncementViewController.asObservable(),
                      pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
                      tasteRecommendCollectionViewHeight: tasteRecommendCollectionViewHeight,
                      updateInterestView: updateInterestView.asObservable(),
                      pushToNormalSearchViewController: pushToNormalSearchViewController,
                      presentInduceLoginViewController: presentInduceLoginViewController.asObservable())
    }
    
    //MARK: - API
    
    func getTodayPopularNovels() -> Observable<TodayPopularNovels> {
        return recommendRepository.getTodayPopularNovels()
    }
    
    func getRealtimePopularFeeds() -> Observable<RealtimePopularFeeds> {
        return recommendRepository.getRealtimePopularFeeds()
    }
    
    func getInterestFeeds() -> Observable<InterestFeeds> {
        return recommendRepository.getInterestFeeds()
    }
    
    func getTasteRecommendNovels() -> Observable<TasteRecommendNovels> {
        return recommendRepository.getTasteRecommendNovels()
    }
}
