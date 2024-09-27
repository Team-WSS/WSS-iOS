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
    
    private let novelReviewRepository: NovelReviewRepository
    
    var readStatus: ReadStatus
    private let novelId: Int
    let novelTitle: String
    
    private var isNovelReviewExist: Bool = false

    private var startDate: Date?
    private var endDate: Date?
    var selectedAttractivePointList: [String] = []
    
    private let minStarRating: Float = 0.0
    private let maxStarRating: Float = 5.0
    private let attractivePointLimit: Int = 3
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
        $0.timeZone = TimeZone(identifier: "ko_KR")
    }
    
    // Output
    
    private let popViewController = PublishRelay<Void>()
    private let readStatusListData = PublishRelay<[ReadStatus]>()
    private let readStatusData = PublishRelay<ReadStatus>()
    private let presentNovelDateSelectModalViewController = PublishRelay<(ReadStatus, Date?, Date?)>()
    private let startDateEndDateData = PublishRelay<[Date?]>()
    private let starRating = BehaviorRelay<Float>(value: 0.0)
    private let attractivePointListData = PublishRelay<[AttractivePoint]>()
    private let isAttractivePointCountOverLimit = PublishRelay<IndexPath>()
    private let presentNovelKeywordSelectModalViewController = PublishRelay<[KeywordData]>()
    let selectedKeywordListData = BehaviorRelay<[KeywordData]>(value: [])
    private let selectedKeywordCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    //MARK: - Life Cycle
    
    init(novelReviewRepository: NovelReviewRepository, readStatus: ReadStatus, novelId: Int, novelTitle: String) {
        self.novelReviewRepository = novelReviewRepository
        self.readStatus = readStatus
        self.novelId = novelId
        self.novelTitle = novelTitle
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let backButtonDidTap: ControlEvent<Void>
        let completeButtonDidTap: ControlEvent<Void>
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
        let readStatusListData: Observable<[ReadStatus]>
        let readStatusData: Observable<ReadStatus>
        let presentNovelDateSelectModalViewController: Observable<(ReadStatus, Date?, Date?)>
        let startDateEndDateData: Observable<[Date?]>
        let starRating: Observable<Float>
        let attractivePointListData: Observable<[AttractivePoint]>
        let isAttractivePointCountOverLimit: Observable<IndexPath>
        let presentNovelKeywordSelectModalViewController: Observable<[KeywordData]>
        let selectedKeywordListData: Observable<[KeywordData]>
        let selectedKeywordCollectionViewHeight: Observable<CGFloat>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .do(onNext: {
                self.readStatusData.accept(self.readStatus)
                self.readStatusListData.accept(ReadStatus.allCases)
                self.attractivePointListData.accept(AttractivePoint.allCases)
            })
            .flatMapLatest {
                self.getNovelReview(novelId: self.novelId)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.isNovelReviewExist = data.status != nil
                if data.startDate != nil || data.endDate != nil {
                    owner.startDate = data.startDate.flatMap { owner.dateFormatter.date(from: $0) } ?? Date()
                    owner.endDate = data.endDate.flatMap { owner.dateFormatter.date(from: $0) } ?? Date()
                }
                owner.startDateEndDateData.accept([owner.startDate, owner.endDate])
                owner.starRating.accept(data.userNovelRating)
                owner.selectedKeywordListData.accept(data.keywords)
                owner.selectedAttractivePointList = data.attractivePoints
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.completeButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .flatMapLatest {
                let startDateString = self.readStatus != .quit ? self.startDate.map { self.dateFormatter.string(from: $0) } : nil
                let endDateString = self.readStatus != .watching ? self.endDate.map { self.dateFormatter.string(from: $0) } : nil
                let keywordIdList = self.selectedKeywordListData.value.map { $0.keywordId }
                
                if self.isNovelReviewExist {
                    return self.putNovelReview(
                        novelId: self.novelId,
                        userNovelRating: self.starRating.value,
                        status: self.readStatus.rawValue,
                        startDate: startDateString,
                        endDate: endDateString,
                        attractivePoints: self.selectedAttractivePointList,
                        keywordIds: keywordIdList
                    )
                } else {
                    return self.postNovelReview(
                        novelId: self.novelId,
                        userNovelRating: self.starRating.value,
                        status: self.readStatus.rawValue,
                        startDate: startDateString,
                        endDate: endDateString,
                        attractivePoints: self.selectedAttractivePointList,
                        keywordIds: keywordIdList
                    )
                }
            }
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: NSNotification.Name("NovelReviewed"), object: nil)
                owner.popViewController.accept(())
            }, onError: { owner, error  in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.statusCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.readStatus = ReadStatus.allCases[indexPath.item]
                owner.readStatusData.accept(owner.readStatus)
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
                guard let selectedKeywordListData = notification.object as? [KeywordData] else { return }
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
    
    //MARK: - API
    
    private func postNovelReview(novelId: Int,
                                 userNovelRating: Float,
                                 status: String,
                                 startDate: String?,
                                 endDate: String?,
                                 attractivePoints: [String],
                                 keywordIds: [Int]) -> Observable<Void> {
        novelReviewRepository.postNovelReview(novelId: novelId,
                                              userNovelRating: userNovelRating,
                                              status: status,
                                              startDate: startDate,
                                              endDate: endDate,
                                              attractivePoints: attractivePoints,
                                              keywordIds: keywordIds)
        .observe(on: MainScheduler.instance)
    }
    
    private func putNovelReview(novelId: Int,
                                 userNovelRating: Float,
                                 status: String,
                                 startDate: String?,
                                 endDate: String?,
                                 attractivePoints: [String],
                                 keywordIds: [Int]) -> Observable<Void> {
        novelReviewRepository.putNovelReview(novelId: novelId,
                                              userNovelRating: userNovelRating,
                                              status: status,
                                              startDate: startDate,
                                              endDate: endDate,
                                              attractivePoints: attractivePoints,
                                              keywordIds: keywordIds)
        .observe(on: MainScheduler.instance)
    }
    
    private func getNovelReview(novelId: Int) -> Observable<NovelReviewResult> {
        novelReviewRepository.getNovelReview(novelId: novelId)
            .observe(on: MainScheduler.instance)
    }
}
