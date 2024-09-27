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
    
    var readStatus: ReadStatus
    private let novelId: Int
    private var selectedAttractivePointList: [String] = []
    
    private let minStarRating: Float = 0.0
    private let maxStarRating: Float = 5.0
    private let attractivePointLimit: Int = 3
    
    // Output
    
    private let popViewController = PublishRelay<Void>()
    private let isCompleteButtonEnabled = BehaviorRelay<Bool>(value: false)
    private let readStatusListData = PublishRelay<[ReadStatus]>()
    private let readStatusData = PublishRelay<ReadStatus>()
    private let starRating = BehaviorRelay<Float>(value: 0.0)
    private let attractivePointListData = PublishRelay<[AttractivePoint]>()
    private let isAttractivePointCountOverLimit = PublishRelay<IndexPath>()
    private let presentNovelKeywordSelectModalViewController = PublishRelay<[String]>()
    let selectedKeywordListData = BehaviorRelay<[String]>(value: [])
    private let selectedKeywordCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    //MARK: - Life Cycle
    
    init(readStatus: ReadStatus, novelId: Int) {
        self.readStatus = readStatus
        self.novelId = novelId
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let backButtonDidTap: ControlEvent<Void>
        let statusCollectionViewItemSelected: Observable<IndexPath>
        let starRatingTapGesture: Observable<(location: CGPoint, width: CGFloat, index: Int)>
        let starRatingPanGesture: Observable<(location: CGPoint, width: CGFloat)>
        let attractivePointCollectionViewItemSelected: Observable<IndexPath>
        let attractivePointCollectionViewItemDeselected: Observable<IndexPath>
        let keywordSearchViewDidTap: Observable<UITapGestureRecognizer>
        let selectedKeywordCollectionViewContentSize: Observable<CGSize?>
        let selectedKeywordCollectionViewItemSelected: Observable<IndexPath>
        let novelReviewKeywordSelectedNotification: Observable<Notification>
    }
    
    struct Output {
        let popViewController: Observable<Void>
        let isCompleteButtonEnabled: Observable<Bool>
        let readStatusListData: Observable<[ReadStatus]>
        let readStatusData: Observable<ReadStatus>
        let starRating: Observable<Float>
        let attractivePointListData: Observable<[AttractivePoint]>
        let isAttractivePointCountOverLimit: Observable<IndexPath>
        let presentNovelKeywordSelectModalViewController: Observable<[String]>
        let selectedKeywordListData: Observable<[String]>
        let selectedKeywordCollectionViewHeight: Observable<CGFloat>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .subscribe(with: self, onNext: { owner, _ in
                owner.readStatusListData.accept(ReadStatus.allCases)
                owner.attractivePointListData.accept(AttractivePoint.allCases)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.statusCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.readStatus = ReadStatus.allCases[indexPath.item]
                owner.isCompleteButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.starRatingTapGesture
            .subscribe(with: self, onNext: { owner, value in
                let halfWidth = value.width / 2
                let isOverHalf = value.location.x > halfWidth
                let rating = Float(value.index) + (isOverHalf ? 1.0 : 0.5)
                
                owner.starRating.accept(rating)
            })
            .disposed(by: disposeBag)
        
        input.starRatingPanGesture
            .subscribe(with: self, onNext: { owner, value in
                let rawRating = Float(value.location.x / value.width * 10).rounded(.up) / 2.0
                let rating = min(max(rawRating, owner.minStarRating), owner.maxStarRating)
                
                owner.starRating.accept(rating)
            })
            .disposed(by: disposeBag)
        
        input.attractivePointCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                if owner.selectedAttractivePointList.count >= owner.attractivePointLimit {
                    owner.isAttractivePointCountOverLimit.accept(indexPath)
                } else {
                    owner.selectedAttractivePointList.append(AttractivePoint.allCases[indexPath.item].rawValue)
                }
            })
            .disposed(by: disposeBag)
        
        input.attractivePointCollectionViewItemDeselected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.selectedAttractivePointList.removeAll { $0 == AttractivePoint.allCases[indexPath.item].rawValue }
            })
            .disposed(by: disposeBag)
        
        input.keywordSearchViewDidTap
            .withLatestFrom(selectedKeywordListData)
            .subscribe(with: self, onNext: { owner, selectedKeywordListData in
                owner.presentNovelKeywordSelectModalViewController.accept(selectedKeywordListData)
            })
            .disposed(by: disposeBag)
        
        input.selectedKeywordCollectionViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: self.selectedKeywordCollectionViewHeight)
            .disposed(by: disposeBag)
        
        input.selectedKeywordCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                var selectedKeywordListData = owner.selectedKeywordListData.value
                selectedKeywordListData.remove(at: indexPath.item)
                owner.selectedKeywordListData.accept(selectedKeywordListData)
            })
            .disposed(by: disposeBag)
        
        input.novelReviewKeywordSelectedNotification
            .subscribe(with: self, onNext: { owner, notification in
                guard let selectedKeywordListData = notification.object as? [String] else { return }
                owner.selectedKeywordListData.accept(selectedKeywordListData)
            })
            .disposed(by: disposeBag)
        
        return Output(popViewController: popViewController.asObservable(),
                      isCompleteButtonEnabled: isCompleteButtonEnabled.asObservable(),
                      readStatusListData: readStatusListData.asObservable(),
                      readStatusData: readStatusData.asObservable(),
                      starRating: starRating.asObservable(),
                      attractivePointListData: attractivePointListData.asObservable(),
                      isAttractivePointCountOverLimit: isAttractivePointCountOverLimit.asObservable(),
                      presentNovelKeywordSelectModalViewController: presentNovelKeywordSelectModalViewController.asObservable(),
                      selectedKeywordListData: selectedKeywordListData.asObservable(),
                      selectedKeywordCollectionViewHeight: selectedKeywordCollectionViewHeight.asObservable())
    }
}
