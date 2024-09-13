//
//  NovelReviewViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelReviewViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let userNovelRepository: UserNovelRepository
    
    let dummyKeywordList = ["후회", "정치물", "피폐", "빙의", "먼치킨", "기억상실"]
    
    //MARK: - Life Cycle
    
    init(userNovelRepository: UserNovelRepository) {
        self.userNovelRepository = userNovelRepository
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let backButtonDidTap: ControlEvent<Void>
        let selectedKeywordCollectionViewContentSize: Observable<CGSize?>
    }
    
    struct Output {
        let popViewController = PublishRelay<Void>()
        let novelReviewStatusData = BehaviorRelay<[NovelReviewStatus]>(value: [.watching, .watched, .quit])
        let attractivePointListData = PublishRelay<[AttractivePoints]>()
        let selectedKeywordListData = PublishRelay<[String]>()
        let selectedKeywordCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.novelReviewStatusData.accept(NovelReviewStatus.allCases)
                output.attractivePointListData.accept(AttractivePoints.allCases)
                output.selectedKeywordListData.accept(owner.dummyKeywordList)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: { _ in
                output.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.selectedKeywordCollectionViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: output.selectedKeywordCollectionViewHeight)
            .disposed(by: disposeBag)
        
        return output
    }
}
