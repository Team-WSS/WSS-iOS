//
//  NovelReviewViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class NovelReviewViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private var readStatus: ReadStatus?
    private var startDate: Date?
    private var endDate: Date?
    private var starRating: Float = 0.0
    private var attractivePointList: [String] = []
    var selectedKeywordList: [String] = []
    
    private let minStarRating: Float = 0.0
    private let maxStarRating: Float = 5.0
    private let attractivePointLimit: Int = 3
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
        $0.timeZone = TimeZone(identifier: "ko_KR")
    }
    
    //MARK: - Life Cycle
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let backButtonDidTap: ControlEvent<Void>
        let statusCollectionViewItemSelected: Observable<IndexPath>
        let dateButtonDidTap: ControlEvent<Void>
        let starRatingTapGesture: Observable<(location: CGPoint, width: CGFloat, index: Int)>
        let starRatingPanGesture: Observable<(location: CGPoint, width: CGFloat)>
        let attractivePointCollectionViewItemSelected: Observable<IndexPath>
        let attractivePointCollectionViewItemDeselected: Observable<IndexPath>
        let keywordSearchViewDidTap: Observable<UITapGestureRecognizer>
        let selectedKeywordCollectionViewContentSize: Observable<CGSize?>
        let selectedKeywordCollectionViewItemSelected: Observable<IndexPath>
        let novelReviewKeywordSelectedNotification: Observable<Notification>
        let novelReviewDateSelectedNotification: Observable<Notification>
    }
    
    struct Output {
        let popViewController = PublishRelay<Void>()
        let isCompleteButtonEnabled = BehaviorRelay<Bool>(value: false)
        let readStatusListData = PublishRelay<[ReadStatus]>()
        let readStatusData = PublishRelay<ReadStatus>()
        let presentNovelDateSelectModalViewController = PublishRelay<ReadStatus>()
        let startDateEndDateData = PublishRelay<[Date?]>()
        let starRating = PublishRelay<Float>()
        let attractivePointListData = PublishRelay<[AttractivePoints]>()
        let isAttractivePointCountOverLimit = PublishRelay<IndexPath>()
        let presentNovelKeywordSelectModalViewController = PublishRelay<[String]>()
        let selectedKeywordListData = PublishRelay<[String]>()
        let selectedKeywordCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.readStatusListData.accept(ReadStatus.allCases)
                output.startDateEndDateData.accept([owner.startDate, owner.endDate])
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
                owner.readStatus = ReadStatus.allCases[indexPath.item]
                output.readStatusData.accept(ReadStatus.allCases[indexPath.item])
                output.isCompleteButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.dateButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                guard let readStatus = self.readStatus else { return }
                output.presentNovelDateSelectModalViewController.accept(readStatus)
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
                if owner.attractivePointList.count >= owner.attractivePointLimit {
                    output.isAttractivePointCountOverLimit.accept(indexPath)
                } else {
                    owner.attractivePointList.append(AttractivePoints.allCases[indexPath.item].rawValue)
                }
            })
            .disposed(by: disposeBag)
        
        input.attractivePointCollectionViewItemDeselected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.attractivePointList.removeAll { $0 == AttractivePoints.allCases[indexPath.item].rawValue }
            })
            .disposed(by: disposeBag)
        
        input.keywordSearchViewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.presentNovelKeywordSelectModalViewController.accept((owner.selectedKeywordList))
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
        
        input.novelReviewKeywordSelectedNotification
            .subscribe(with: self, onNext: { owner, notification in
                guard let selectedKeywordList = notification.object as? [String] else { return }
                owner.selectedKeywordList = selectedKeywordList
                output.selectedKeywordListData.accept(owner.selectedKeywordList)
            })
            .disposed(by: disposeBag)
        
        input.novelReviewDateSelectedNotification
            .subscribe(with: self, onNext: { owner, notification in
                guard let startDateEndDateData = notification.object as? [Date] else { return }
                owner.startDate = startDateEndDateData[0]
                owner.endDate = startDateEndDateData[1]
                output.startDateEndDateData.accept([owner.startDate, owner.endDate])
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
