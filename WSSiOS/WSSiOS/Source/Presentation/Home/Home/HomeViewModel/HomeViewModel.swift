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
    
    private let isLogined = APIConstants.isLogined
    
    // 오늘의 인기작
    private let todayPopularList = BehaviorRelay<[TodayPopularNovel]>(value: [])
    
    // 지금 뜨는 수다글
    private let realtimePopularList = PublishSubject<[RealtimePopularFeed]>()
    private let realtimePopularDataRelay = BehaviorRelay<[[RealtimePopularFeed]]>(value: [])
    
    // 관심글
    private let interestList = BehaviorRelay<[InterestFeed]>(value: [])
    private let updateInterestView = PublishRelay<(Bool, Bool)>()
    private let pushToNormalSearchViewController = PublishRelay<Void>()
    
    // 취향추천
    private let tasteRecommendList = BehaviorRelay<[TasteRecommendNovel]>(value: [])
    private let updateTasteRecommendView = PublishRelay<(Bool, Bool)>()
    private let pushToMyPageViewController = PublishRelay<Void>()
    
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let pushToAnnouncementViewController = PublishRelay<Void>()
    let showInduceLoginModalView = PublishRelay<Void>()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let todayPopularCellSelected: ControlEvent<IndexPath>
        let interestCellSelected: ControlEvent<IndexPath>
        let tasteRecommendCellSelected: ControlEvent<IndexPath>
        let announcementButtonDidTap: ControlEvent<Void>
        let registerInterestNovelButtonTapped: ControlEvent<Void>
        let setPreferredGenresButtonTapped: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var todayPopularList: Observable<[TodayPopularNovel]>
        
        var realtimePopularList: Observable<[RealtimePopularFeed]>
        var realtimePopularData: Observable<[[RealtimePopularFeed]]>
        
        var interestList: Observable<[InterestFeed]>
        let updateInterestView: Observable<(Bool, Bool)>
        let pushToNormalSearchViewController: Observable<Void>
        
        var tasteRecommendList: Observable<[TasteRecommendNovel]>
        let updateTasteRecommendView: Observable<(Bool, Bool)>
        let pushToMyPageViewController: Observable<Void>
        
        let pushToNovelDetailViewController: Observable<Int>
        let pushToAnnouncementViewController: Observable<Void>
        let showInduceLoginModalView: Observable<Void>
    }
    
    //MARK: - init
    
    init(recommendRepository: RecommendRepository) {
        self.recommendRepository = recommendRepository
    }
}

extension HomeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest {
                let realtimeFeedsObservable = self.getRealtimePopularFeeds()
                let interestFeedsObservable = self.isLogined ? self.getInterestFeeds() : Observable.just(InterestFeeds(recommendFeeds: []))
                let tasteRecommendNovelsObservable = self.isLogined ? self.getTasteRecommendNovels() : Observable.just(TasteRecommendNovels(tasteNovels: []))
                
                return Observable.zip(realtimeFeedsObservable,
                                      interestFeedsObservable,
                                      tasteRecommendNovelsObservable)
            }
            .subscribe(with: self, onNext: { owner, data in
                let realtimeFeeds = data.0
                let interestFeeds = data.1
                let tasteRecommendNovels = data.2
                
                owner.realtimePopularList.onNext(realtimeFeeds.popularFeeds)
                let groupedData = stride(from: 0, to: realtimeFeeds.popularFeeds.count, by: 3)
                    .map { index in
                        Array(realtimeFeeds.popularFeeds[index..<min(index + 3, realtimeFeeds.popularFeeds.count)])
                    }
                owner.realtimePopularDataRelay.accept(groupedData)
                
                if owner.isLogined {
                    owner.interestList.accept(interestFeeds.recommendFeeds)
                    owner.updateInterestView.accept((true, interestFeeds.recommendFeeds.isEmpty))
                    
                    owner.tasteRecommendList.accept(tasteRecommendNovels.tasteNovels)
                    owner.updateTasteRecommendView.accept((true, tasteRecommendNovels.tasteNovels.isEmpty))
                } else {
                    owner.updateInterestView.accept((false, true))
                    owner.updateTasteRecommendView.accept((false, true))
                }
            }, onError: { owner, error in
                owner.realtimePopularList.onError(error)
            })
            .disposed(by: disposeBag)
        
        self.getTodayPopularNovels()
            .subscribe(with: self, onNext: { owner, data in
                owner.todayPopularList.accept(data.popularNovels)
            }, onError: { owner, error in
                dump(error)
            })
            .disposed(by: disposeBag)
        
        input.todayPopularCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                if owner.isLogined {
                    let novelId = owner.todayPopularList.value[indexPath.row].novelId
                    owner.pushToNovelDetailViewController.accept(novelId)
                } else {
                    owner.showInduceLoginModalView.accept(())
                }
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
                if owner.isLogined {
                    owner.pushToAnnouncementViewController.accept(())
                } else {
                    owner.showInduceLoginModalView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.registerInterestNovelButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                if owner.isLogined {
                    owner.pushToMyPageViewController.accept(())
                } else {
                    owner.showInduceLoginModalView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.setPreferredGenresButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                owner.showInduceLoginModalView.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(todayPopularList: todayPopularList.asObservable(),
                      realtimePopularList: realtimePopularList.asObservable(),
                      realtimePopularData: realtimePopularDataRelay.asObservable(),
                      interestList: interestList.asObservable(),
                      updateInterestView: updateInterestView.asObservable(),
                      pushToNormalSearchViewController: pushToNormalSearchViewController.asObservable(),
                      tasteRecommendList: tasteRecommendList.asObservable(),
                      updateTasteRecommendView: updateTasteRecommendView.asObservable(),
                      pushToMyPageViewController: pushToMyPageViewController.asObservable(),
                      pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
                      pushToAnnouncementViewController: pushToAnnouncementViewController.asObservable(),
                      showInduceLoginModalView: showInduceLoginModalView.asObservable())
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
