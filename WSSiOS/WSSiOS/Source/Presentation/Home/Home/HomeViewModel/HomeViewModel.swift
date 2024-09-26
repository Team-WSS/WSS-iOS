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
    
    private let todayPopularList = PublishSubject<[TodayPopularNovel]>()
    private let realtimePopularList = PublishSubject<[RealtimePopularFeed]>()
    private let realtimePopularDataRelay = BehaviorRelay<[[RealtimePopularFeed]]>(value: [])
    private let interestList = PublishSubject<[InterestFeed]>()
    private let tasteRecommendList = PublishSubject<[TasteRecommendNovel]>()
    
    private let todayPopularCellIndexPath = PublishRelay<IndexPath>()
    private let tasteRecommendCellIndexPath = PublishRelay<IndexPath>()
    
    // MARK: - Inputs
    
    struct Input {
        let announcementButtonTapped: ControlEvent<Void>
        let todayPopularCellSelected: ControlEvent<IndexPath>
        let tasteRecommendCellSelected: ControlEvent<IndexPath>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var todayPopularList: Observable<[TodayPopularNovel]>
        var realtimePopularList: Observable<[RealtimePopularFeed]>
        var realtimePopularData: Observable<[[RealtimePopularFeed]]>
        var interestList: Observable<[InterestFeed]>
        var tasteRecommendList: Observable<[TasteRecommendNovel]>
        let navigateToAnnouncementView: Observable<Void>
        let navigateToNovelDetailInfoView: Observable<(IndexPath, Int)>
    }
    
    //MARK: - init
    
    init(recommendRepository: RecommendRepository) {
        self.recommendRepository = recommendRepository
    }
}

extension HomeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        recommendRepository.getTodayPopularNovels()
            .subscribe(with: self, onNext: { owner, data in
                owner.todayPopularList.onNext(data.popularNovels)
            }, onError: { owner, error in
                owner.todayPopularList.onError(error)
            })
            .disposed(by: disposeBag)
        
        recommendRepository.getRealtimePopularFeeds()
            .subscribe(with: self, onNext: { owner, data in
                owner.realtimePopularList.onNext(data.popularFeeds)
                
                let groupedData = stride(from: 0, to: data.popularFeeds.count, by: 3)
                    .map { index in
                        Array(data.popularFeeds[index..<min(index + 3, data.popularFeeds.count)])
                    }
                self.realtimePopularDataRelay.accept(groupedData)
            }, onError: { owner, error in
                owner.realtimePopularList.onError(error)
            })
            .disposed(by: disposeBag)
        
        recommendRepository.getInterestNovels()
            .subscribe(with: self, onNext: { owner, data in
                owner.interestList.onNext(data.recommendFeeds)
            }, onError: { owner, error in
                owner.interestList.onError(error)
            })
            .disposed(by: disposeBag)
        
        recommendRepository.getTasteRecommendNovels()
            .subscribe(with: self, onNext: { owner, data in
                owner.tasteRecommendList.onNext(data.tasteNovels)
            }, onError: { owner, error in
                owner.tasteRecommendList.onError(error)
            })
            .disposed(by: disposeBag)
        
        input.todayPopularCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.todayPopularCellIndexPath.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        input.tasteRecommendCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.tasteRecommendCellIndexPath.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        let navigateToAnnouncementView = input.announcementButtonTapped.asObservable()
        
        let navigateToNovelDetailInfoView = Observable.merge(
            todayPopularCellIndexPath.map { indexPath in (indexPath, 0) },
            tasteRecommendCellIndexPath.map { indexPath in (indexPath, 1) }
        )
        
        return Output(todayPopularList: todayPopularList.asObservable(),
                      realtimePopularList: realtimePopularList.asObservable(),
                      realtimePopularData: realtimePopularDataRelay.asObservable(),
                      interestList: interestList.asObservable(),
                      tasteRecommendList: tasteRecommendList.asObservable(),
                      navigateToAnnouncementView: navigateToAnnouncementView.asObservable(),
                      navigateToNovelDetailInfoView: navigateToNovelDetailInfoView)
    }
}
