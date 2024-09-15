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
    
    private var novelReviewStatus: NovelReviewStatus?
    private var starRating: Float = 0.0
    var selectedKeywordList: [String] = ["후회", "정치물", "피폐", "빙의", "먼치킨", "기억상실"]
    
    //MARK: - Life Cycle
    
    init(userNovelRepository: UserNovelRepository) {
        self.userNovelRepository = userNovelRepository
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let backButtonDidTap: ControlEvent<Void>
        let statusCollectionViewItemSelected: Observable<IndexPath>
        let starRatingTapGesture: Observable<(location: CGPoint, width: CGFloat, index: Int)>
        let selectedKeywordCollectionViewContentSize: Observable<CGSize?>
        let selectedKeywordCollectionViewItemSelected: Observable<IndexPath>
    }
    
    struct Output {
        let popViewController = PublishRelay<Void>()
        let novelReviewStatusData = BehaviorRelay<[NovelReviewStatus]>(value: [.watching, .watched, .quit])
        let starRating = PublishRelay<Float>()
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
                output.selectedKeywordListData.accept(owner.selectedKeywordList)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: { _ in
                output.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.statusCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.novelReviewStatus = NovelReviewStatus.allCases[indexPath.item]
            })
            .disposed(by: disposeBag)
        
        input.starRatingTapGesture
            .subscribe(with: self, onNext: { owner, value in
                let halfWidth = value.width / 2
                let isOverHalf = value.location.x > halfWidth
                let rating = Float(value.index) + (isOverHalf ? 1.0 : 0.5)
                
                owner.starRating = rating
                output.starRating.accept(rating)
            })
            .disposed(by: disposeBag)
        
        input.selectedKeywordCollectionViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: output.selectedKeywordCollectionViewHeight)
            .disposed(by: disposeBag)
        
        input.selectedKeywordCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.selectedKeywordList.remove(at: indexPath.item)
                output.selectedKeywordListData.accept(owner.selectedKeywordList)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
