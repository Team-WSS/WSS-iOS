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
    
    let cellsDataRelay = BehaviorRelay<[[RealtimePopularFeed]]>(value: [])
    
    // MARK: - Inputs
    
    struct Input {
        let announcementButtonTapped: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var todayPopularList = BehaviorRelay<[TodayPopularNovel]>(value: [])
        var realtimePopularList = BehaviorRelay<[RealtimePopularFeed]>(value: [])
        var interestList = BehaviorRelay<[InterestFeed]>(value: [])
        var tasteRecommendList = BehaviorRelay<[TasteRecommendNovel]>(value: [])
        let navigateToAnnoucementView = PublishRelay<Bool>()
    }
    
    //MARK: - init
    
    init(recommendRepository: RecommendRepository) {
        self.recommendRepository = recommendRepository
    }
}

extension HomeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        recommendRepository.getTodayPopularNovels()
            .subscribe(with: self, onNext: { owner, data in
                output.todayPopularList.accept(data.popularNovels)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        recommendRepository.getRealtimePopularFeeds()
            .subscribe(with: self, onNext: { owner, data in
                output.realtimePopularList.accept(data.popularFeeds)
                
                let groupedData = stride(from: 0, to: data.popularFeeds.count, by: 3)
                    .map { index in
                        Array(data.popularFeeds[index..<min(index + 3, data.popularFeeds.count)])
                    }
                self.cellsDataRelay.accept(groupedData)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        recommendRepository.getInterestNovels()
            .subscribe(with: self, onNext: { owner, data in
                output.interestList.accept(data.recommendFeeds)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        recommendRepository.getTasteRecommendNovels()
            .subscribe(with: self, onNext: { owner, data in
                output.tasteRecommendList.accept(data.tasteNovels)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.announcementButtonTapped
            .subscribe(onNext: { _ in
                output.navigateToAnnoucementView.accept(true)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
