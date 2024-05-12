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
    
    private let recommendRepository: DefaultRecommendRepository
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let announcementButtonTapped: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var todayPopularList = BehaviorRelay<[TodayPopularNovel]>(value: [])
        var interestList = BehaviorRelay<[InterestFeed]>(value: [])
        var tasteRecommendList = BehaviorRelay<[TasteRecommendNovel]>(value: [])
        let navigateToAnnoucementView = PublishRelay<Bool>()
    }
    
    //MARK: - init
    
    init(recommendRepository: DefaultRecommendRepository) {
        self.recommendRepository = recommendRepository
    }
    
    //MARK: - API
    
}

extension HomeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        recommendRepository.getTestTodayPopularNovels()
            .subscribe(with: self, onNext: { owner, data in
                output.todayPopularList.accept(data)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        recommendRepository.getTestInterestNovels()
            .subscribe(with: self, onNext: { owner, data in
                output.interestList.accept(data)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        recommendRepository.getTestTasteRecommendNovels()
            .subscribe(with: self, onNext: { owner, data in
                output.tasteRecommendList.accept(data)
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
