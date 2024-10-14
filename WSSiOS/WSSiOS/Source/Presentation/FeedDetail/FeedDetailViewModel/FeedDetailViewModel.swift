//
//  FeedDetailViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class FeedDetailViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let feedDetailRepository: FeedDetailRepository
    private let disposeBag = DisposeBag()
    let feedId: Int
    
    private let feedData = PublishSubject<Feed>()
    private let commentsData = BehaviorRelay<[FeedComment]>(value: [])
    private let replyCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    private let likeCount = BehaviorRelay<Int>(value: 0)
    private let likeButtonState = BehaviorRelay<Bool>(value: false)
    
    private let showDropdownView = BehaviorRelay<Bool>(value: false)
    private let isMyFeed = BehaviorRelay<Bool>(value: false)
 
    //MARK: - Life Cycle
    
    init(feedDetailRepository: FeedDetailRepository, feedId: Int) {
        self.feedDetailRepository = feedDetailRepository
        self.feedId = feedId
    }
    
    struct Input {
        let backButtonTapped: ControlEvent<Void>
        let replyCollectionViewContentSize: Observable<CGSize?>
        let likeButtonTapped: ControlEvent<Void>
        
        let dropdownButtonTapped: ControlEvent<Void>
        let spoilerButtonTapped: ControlEvent<Void>
        let improperButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let feedData: Observable<Feed>
        let commentsData: Driver<[FeedComment]>
        let replyCollectionViewHeight: Driver<CGFloat>
        let likeCount: Driver<Int>
        let likeButtonEnabled: Driver<Bool>
        let backButtonEnabled: Driver<Void>
        
        let showDropdownView: Driver<Bool>
        let isMyFeed: Driver<Bool>
        let showSpoilerAlertView: Observable<Void>
        let showImproperAlertView: Observable<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        getSingleFeed(feedId)
            .subscribe(with: self, onNext: { owner, data in
                owner.feedData.onNext(data)
                owner.likeButtonState.accept(data.isLiked)
                owner.likeCount.accept(data.likeCount)
                owner.isMyFeed.accept(data.isMyFeed)
            }, onError: { owner, error in
                owner.feedData.onError(error)
            })
            .disposed(by: disposeBag)
        
        getSingleFeedComments(feedId)
            .subscribe(with: self, onNext: { owner, data in
                owner.commentsData.accept(data.comments)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        let replyCollectionViewContentSize = input.replyCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        input.likeButtonTapped
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(likeButtonState)
            .flatMapLatest { isLiked -> Observable<Void> in
                let request: Observable<Void>
                request = isLiked ? self.deleteFeedLike(self.feedId) : self.postFeedLike(self.feedId)
                return request
                    .do(onNext: {
                        self.likeButtonState.accept(!isLiked)
                        let newCount = isLiked ? self.likeCount.value - 1 : self.likeCount.value + 1
                        self.likeCount.accept(newCount)
                    })
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        let backButtonEnabled = input.backButtonTapped.asDriver()
        let showSpoilerAlertView = input.spoilerButtonTapped.asObservable()
        let showImproperAlertView = input.improperButtonTapped.asObservable()
        
        input.dropdownButtonTapped
            .withLatestFrom(showDropdownView)
            .map { !$0 }
            .bind(to: showDropdownView)
            .disposed(by: disposeBag)
        
        return Output(feedData: feedData.asObservable(),
                      commentsData: commentsData.asDriver(),
                      replyCollectionViewHeight: replyCollectionViewContentSize,
                      likeCount: likeCount.asDriver(),
                      likeButtonEnabled: likeButtonState.asDriver(),
                      backButtonEnabled: backButtonEnabled,
                      showDropdownView: showDropdownView.asDriver(),
                      isMyFeed: isMyFeed.asDriver(),
                      showSpoilerAlertView: showSpoilerAlertView,
                      showImproperAlertView: showImproperAlertView)
    }
    
    //MARK: = API
    
    func getSingleFeed(_ feedId: Int) -> Observable<Feed> {
        return feedDetailRepository.getSingleFeedData(feedId: feedId)
    }
    
    func getSingleFeedComments(_ feedId: Int) -> Observable<FeedComments> {
        return feedDetailRepository.getSingleFeedComments(feedId: feedId)
    }
    
    func postFeedLike(_ feedId: Int) -> Observable<Void> {
        return feedDetailRepository.postFeedLike(feedId: feedId)
    }
    
    func deleteFeedLike(_ feedId: Int) -> Observable<Void> {
        return feedDetailRepository.deleteFeedLike(feedId: feedId)
    }
    
    func postSpoilerFeed(_ feedId: Int) -> Observable<Void> {
        return feedDetailRepository.postSpoilerFeed(feedId: feedId)
    }
    
    func postImpertinenceFeed(_ feedId: Int) -> Observable<Void> {
        return feedDetailRepository.postImpertinenceFeed(feedId: feedId)
    }
    
    //MARK: - Custom Method
    
    func replyContentForItemAt(indexPath: IndexPath) -> String? {
        guard indexPath.item < commentsData.value.count else {
            return nil
        }
        
        return commentsData.value[indexPath.item].commentContent
    }
    
    func replyContentNumberOfLines(indexPath: IndexPath) -> Int? {
        guard indexPath.item < commentsData.value.count else {
            return nil
        }
        
        let commentContent = commentsData.value[indexPath.item].commentContent
        
        let label = UILabel()
        label.applyWSSFont(.body2, with: commentContent)
        label.numberOfLines = 0
        
        let maxSize = CGSize(width: UIScreen.main.bounds.width - 128,
                             height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = label.sizeThatFits(maxSize)
        
        let lineHeight = UIFont.Body2.lineHeight
        let numberOfLines = Int(round(requiredSize.height / lineHeight))
        
        return numberOfLines
    }
}
