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
    private var attractivePointList: [String] = []
    var selectedKeywordList: [String] = ["후회", "정치물", "피폐", "빙의", "먼치킨", "기억상실"]
    
    private let minStarRating: Float = 0.0
    private let maxStarRating: Float = 5.0
    
    //MARK: - Life Cycle
    
    init(userNovelRepository: UserNovelRepository) {
        self.userNovelRepository = userNovelRepository
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let backButtonDidTap: ControlEvent<Void>
        let statusCollectionViewItemSelected: Observable<IndexPath>
        let starRatingTapGesture: Observable<(location: CGPoint, width: CGFloat, index: Int)>
        let starRatingPanGesture: Observable<(location: CGPoint, width: CGFloat)>
        let attractivePointCollectionViewItemSelected: Observable<IndexPath>
        let attractivePointCollectionViewItemDeselected: Observable<IndexPath>
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
        
        input.starRatingPanGesture
            .subscribe(with: self, onNext: { owner, value in
                let rawRating = Float(value.location.x / value.width * 10).rounded(.up) / 2.0
                let rating = min(max(rawRating, owner.minStarRating), owner.maxStarRating)
                
                owner.starRating = rating
                output.starRating.accept(rating)
            })
            .disposed(by: disposeBag)
        
        input.attractivePointCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.attractivePointList.append(AttractivePoints.allCases[indexPath.item].rawValue)
            })
            .disposed(by: disposeBag)
        
        input.attractivePointCollectionViewItemDeselected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.attractivePointList.removeAll { $0 == AttractivePoints.allCases[indexPath.item].rawValue }
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
