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
    
    var readStatus: ReadStatus
    private var selectedAttractivePointList: [String] = []

    private var startDate: Date?
    private var endDate: Date?
    private var attractivePointList: [String] = []
    var selectedKeywordList: [String] = []
    
    private let minStarRating: Float = 0.0
    private let maxStarRating: Float = 5.0
    private let attractivePointLimit: Int = 3
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
        $0.timeZone = TimeZone(identifier: "ko_KR")
    }
    
    // Output
    
    private let popViewController = PublishRelay<Void>()
    private let isCompleteButtonEnabled = BehaviorRelay<Bool>(value: false)
    private let readStatusListData = PublishRelay<[ReadStatus]>()
    private let readStatusData = PublishRelay<ReadStatus>()
    private let presentNovelDateSelectModalViewController = PublishRelay<(ReadStatus, Date?, Date?)>()
    private let startDateEndDateData = PublishRelay<[Date?]>()
    private let starRating = BehaviorRelay<Float>(value: 0.0)
    private let attractivePointListData = PublishRelay<[AttractivePoints]>()
    private let isAttractivePointCountOverLimit = PublishRelay<IndexPath>()
    private let presentNovelKeywordSelectModalViewController = PublishRelay<[String]>()
    let selectedKeywordListData = BehaviorRelay<[String]>(value: [])
    private let selectedKeywordCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    //MARK: - Life Cycle
    
    init(readStatus: ReadStatus) {
        self.readStatus = readStatus
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let backButtonDidTap: ControlEvent<Void>
        let statusCollectionViewItemSelected: Observable<IndexPath>
        let dateLabelTapGesture: Observable<UITapGestureRecognizer>
        let starRatingTapGesture: Observable<(location: CGPoint, width: CGFloat, index: Int)>
        let starRatingPanGesture: Observable<(location: CGPoint, width: CGFloat)>
        let attractivePointCollectionViewItemSelected: Observable<IndexPath>
        let attractivePointCollectionViewItemDeselected: Observable<IndexPath>
        let keywordSearchViewDidTap: Observable<UITapGestureRecognizer>
        let selectedKeywordCollectionViewContentSize: Observable<CGSize?>
        let selectedKeywordCollectionViewItemSelected: Observable<IndexPath>
        let novelReviewKeywordSelectedNotification: Observable<Notification>
        let novelReviewDateSelectedNotification: Observable<Notification>
        let novelReviewDateRemovedNotification: Observable<Notification>
    }
    
    struct Output {
        let popViewController: Observable<Void>
        let isCompleteButtonEnabled: Observable<Bool>
        let readStatusListData: Observable<[ReadStatus]>
        let readStatusData: Observable<ReadStatus>
        let presentNovelDateSelectModalViewController: Observable<(ReadStatus, Date?, Date?)>
        let startDateEndDateData: Observable<[Date?]>
        let starRating: Observable<Float>
        let attractivePointListData: Observable<[AttractivePoints]>
        let isAttractivePointCountOverLimit: Observable<IndexPath>
        let presentNovelKeywordSelectModalViewController: Observable<[String]>
        let selectedKeywordListData: Observable<[String]>
        let selectedKeywordCollectionViewHeight: Observable<CGFloat>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .subscribe(with: self, onNext: { owner, _ in
                owner.readStatusData.accept(owner.readStatus)
                owner.readStatusListData.accept(ReadStatus.allCases)
                owner.startDateEndDateData.accept([owner.startDate, owner.endDate])
                owner.attractivePointListData.accept(AttractivePoints.allCases)
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
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
                owner.readStatusData.accept(owner.readStatus)
                owner.isCompleteButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.dateLabelTapGesture
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentNovelDateSelectModalViewController.accept((owner.readStatus,
                                                                         owner.startDate,
                                                                         owner.endDate))
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
                    owner.selectedAttractivePointList.append(AttractivePoints.allCases[indexPath.item].rawValue)
                }
            })
            .disposed(by: disposeBag)
        
        input.attractivePointCollectionViewItemDeselected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.selectedAttractivePointList.removeAll { $0 == AttractivePoints.allCases[indexPath.item].rawValue }
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
        
        input.novelReviewDateSelectedNotification
            .subscribe(with: self, onNext: { owner, notification in
                guard let startDateEndDateData = notification.object as? [Date] else { return }
                owner.startDate = startDateEndDateData[0]
                owner.endDate = startDateEndDateData[1]
                owner.startDateEndDateData.accept([owner.startDate, owner.endDate])
            })
            .disposed(by: disposeBag)
        
        input.novelReviewDateRemovedNotification
            .subscribe(with: self, onNext: { owner, notification in
                owner.startDate = nil
                owner.endDate = nil
                owner.startDateEndDateData.accept([owner.startDate, owner.endDate])
            })
            .disposed(by: disposeBag)

        return Output(popViewController: popViewController.asObservable(),
                      isCompleteButtonEnabled: isCompleteButtonEnabled.asObservable(),
                      readStatusListData: readStatusListData.asObservable(),
                      readStatusData: readStatusData.asObservable(),
                      presentNovelDateSelectModalViewController: presentNovelDateSelectModalViewController.asObservable(),
                      startDateEndDateData: startDateEndDateData.asObservable(),
                      starRating: starRating.asObservable(),
                      attractivePointListData: attractivePointListData.asObservable(),
                      isAttractivePointCountOverLimit: isAttractivePointCountOverLimit.asObservable(),
                      presentNovelKeywordSelectModalViewController: presentNovelKeywordSelectModalViewController.asObservable(),
                      selectedKeywordListData: selectedKeywordListData.asObservable(),
                      selectedKeywordCollectionViewHeight: selectedKeywordCollectionViewHeight.asObservable())
    }
}
