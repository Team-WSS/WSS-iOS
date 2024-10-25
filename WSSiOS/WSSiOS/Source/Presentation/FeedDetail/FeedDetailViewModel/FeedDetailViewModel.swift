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
    
    let showSpoilerAlertView = PublishRelay<Void>()
    let showImproperAlertView = PublishRelay<Void>()
    let pushToFeedEditViewController = PublishRelay<Void>()
    let showDeleteAlertView = PublishRelay<Void>()
    
    //MARK: - Life Cycle
    
    init(feedDetailRepository: FeedDetailRepository, feedId: Int) {
        self.feedDetailRepository = feedDetailRepository
        self.feedId = feedId
    }
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let replyCollectionViewContentSize: Observable<CGSize?>
        let likeButtonDidTap: ControlEvent<Void>
        
        let dotsButtonDidTap: ControlEvent<Void>
        let dropdownButtonDidTap: Observable<DropdownButtonType>
    }
    
    struct Output {
        let feedData: Observable<Feed>
        let commentsData: Driver<[FeedComment]>
        let replyCollectionViewHeight: Driver<CGFloat>
        let likeCount: Driver<Int>
        let likeButtonToggle: Driver<Bool>
        let popViewController: Driver<Void>
        
        let showDropdownView: Driver<Bool>
        let isMyFeed: Driver<Bool>
        let showSpoilerAlertView: Observable<Void>
        let showImproperAlertView: Observable<Void>
        let pushToFeedEditViewController: Observable<Void>
        let showDeleteAlertView: Observable<Void>
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
        
        input.likeButtonDidTap
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
        
        let popViewController = input.backButtonDidTap.asDriver()
        
        input.dotsButtonDidTap
            .withLatestFrom(showDropdownView)
            .map { !$0 }
            .bind(to: showDropdownView)
            .disposed(by: disposeBag)
        
        input.dropdownButtonDidTap
            .map { ($0, self.isMyFeed.value) }
            .subscribe( with: self, onNext: { owner, result in
                switch result {
                case (.top, true): owner.pushToFeedEditViewController.accept(())
                case (.bottom, true): owner.showDeleteAlertView.accept(())
                case (.top, false): owner.showSpoilerAlertView.accept(())
                case (.bottom, false): owner.showImproperAlertView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        return Output(feedData: feedData.asObservable(),
                      commentsData: commentsData.asDriver(),
                      replyCollectionViewHeight: replyCollectionViewContentSize,
                      likeCount: likeCount.asDriver(),
                      likeButtonToggle: likeButtonState.asDriver(),
                      popViewController: popViewController,
                      showDropdownView: showDropdownView.asDriver(),
                      isMyFeed: isMyFeed.asDriver(),
                      showSpoilerAlertView: showSpoilerAlertView.asObservable(),
                      showImproperAlertView: showImproperAlertView.asObservable(),
                      pushToFeedEditViewController: pushToFeedEditViewController.asObservable(),
                      showDeleteAlertView: showDeleteAlertView.asObservable())
    }
    
    //MARK: - API
    
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
    
    func deleteFeed(_ feedId: Int) -> Observable<Void> {
        return feedDetailRepository.deleteFeed(feedId: feedId)
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

enum DropdownButtonType {
    case top
    case bottom
}
