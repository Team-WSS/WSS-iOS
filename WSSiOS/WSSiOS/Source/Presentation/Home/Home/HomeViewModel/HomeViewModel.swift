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
    private let isLoggedIn: Bool
    let showInduceLoginModalView = BehaviorRelay<Bool>(value: false)
    
    private let todayPopularList = PublishSubject<[TodayPopularNovel]>()
    private let realtimePopularList = PublishSubject<[RealtimePopularFeed]>()
    private let realtimePopularDataRelay = BehaviorRelay<[[RealtimePopularFeed]]>(value: [])
    private let interestList = PublishSubject<[InterestFeed]>()
    private let tasteRecommendList = PublishSubject<[TasteRecommendNovel]>()
    
    private let todayPopularCellIndexPath = PublishRelay<IndexPath>()
    private let interestCellIndexPath = PublishRelay<IndexPath>()
    private let tasteRecommendCellIndexPath = PublishRelay<IndexPath>()
    private let navigateToAnnouncementView = PublishRelay<Void>()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let announcementButtonTapped: ControlEvent<Void>
        let registerInterestNovelButtonTapped: ControlEvent<Void>
        let setPreferredGenresButtonTapped: ControlEvent<Void>
        let induceModalViewLoginButtonTapped: ControlEvent<Void>
        let induceModalViewCancelButtonTapped: ControlEvent<Void>
        let todayPopularCellSelected: ControlEvent<IndexPath>
        let interestCellSelected: ControlEvent<IndexPath>
        let tasteRecommendCellSelected: ControlEvent<IndexPath>
        let tasteRecommendCollectionViewContentSize: Observable<CGSize?>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var todayPopularList: Observable<[TodayPopularNovel]>
        var realtimePopularList: Observable<[RealtimePopularFeed]>
        var realtimePopularData: Observable<[[RealtimePopularFeed]]>
        var interestList: Observable<[InterestFeed]>
        var tasteRecommendList: Observable<[TasteRecommendNovel]>
        let navigateToAnnouncementView: Observable<Void>
        let navigateToNormalSearchView: Observable<Void>
        let navigateToLoginView: Observable<Void>
        let showInduceLoginModalView: Driver<Bool>
        let navigateToNovelDetailInfoView: Observable<(IndexPath, Int)>
        let tasteRecommendCollectionViewHeight: Driver<CGFloat>
    }
    
    //MARK: - init
    
    init(recommendRepository: RecommendRepository, isLoggedIn: Bool) {
        self.recommendRepository = recommendRepository
        self.isLoggedIn = isLoggedIn
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
        
        input.viewWillAppearEvent
            .flatMapLatest {
                self.recommendRepository.getRealtimePopularFeeds()
            }
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
        
        if isLoggedIn {
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
        }
        
        input.setPreferredGenresButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                owner.showInduceLoginModalView.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.induceModalViewCancelButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                owner.showInduceLoginModalView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.todayPopularCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                if owner.isLoggedIn {
                    owner.todayPopularCellIndexPath.accept(indexPath)
                } else {
                    owner.showInduceLoginModalView.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        input.interestCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.interestCellIndexPath.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        input.tasteRecommendCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.tasteRecommendCellIndexPath.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        input.announcementButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                if owner.isLoggedIn {
                    owner.navigateToAnnouncementView.accept(())
                } else {
                    owner.showInduceLoginModalView.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        let navigateToNormalSearchView = input.registerInterestNovelButtonTapped.asObservable()
        let navigateToLoginView = input.induceModalViewLoginButtonTapped.asObservable()
        
        let navigateToNovelDetailInfoView = Observable.merge(
            todayPopularCellIndexPath.map { indexPath in (indexPath, 0) },
            interestCellIndexPath.map { indexPath in (indexPath, 1) },
            tasteRecommendCellIndexPath.map { indexPath in (indexPath, 2) }
        )
        
        let tasteRecommendCollectionViewHeight = input.tasteRecommendCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        return Output(todayPopularList: todayPopularList.asObservable(),
                      realtimePopularList: realtimePopularList.asObservable(),
                      realtimePopularData: realtimePopularDataRelay.asObservable(),
                      interestList: interestList.asObservable(),
                      tasteRecommendList: tasteRecommendList.asObservable(),
                      navigateToAnnouncementView: navigateToAnnouncementView.asObservable(),
                      navigateToNormalSearchView: navigateToNormalSearchView,
                      navigateToLoginView: navigateToLoginView,
                      showInduceLoginModalView: showInduceLoginModalView.asDriver(),
                      navigateToNovelDetailInfoView: navigateToNovelDetailInfoView,
                      tasteRecommendCollectionViewHeight: tasteRecommendCollectionViewHeight)
    }
}
