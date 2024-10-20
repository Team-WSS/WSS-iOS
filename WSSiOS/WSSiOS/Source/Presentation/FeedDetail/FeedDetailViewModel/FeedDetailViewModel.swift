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
    private let feedId: Int
    
    private let feedData = PublishSubject<Feed>()
    private let commentsData = BehaviorRelay<[FeedComment]>(value: [])
    private let replyCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    // 작품 연결
    private var novelId: Int?
    private let presentNovelDetailViewController = PublishRelay<Int>()
    
    // 관심 버튼
    private let likeCount = BehaviorRelay<Int>(value: 0)
    private let likeButtonState = BehaviorRelay<Bool>(value: false)
    private let backButtonState = PublishRelay<Void>()
    
    // 댓글 작성
    private let commentCount = BehaviorRelay<Int>(value: 0)
    private let endEditing = PublishRelay<Bool>()
    private var updatedCommentContent: String = ""
    private var isValidCommentContent: Bool = false
    private let maximumCommentContentCount: Int = 500
    private let commentContentWithLengthLimit = BehaviorRelay<String>(value: "")
    private let showPlaceholder = BehaviorRelay<Bool>(value: true)
    private let sendButtonEnabled = BehaviorRelay<Bool>(value: false)
    private let textViewEmpty = BehaviorRelay<Bool>(value: true)
    
    //MARK: - Life Cycle
    
    init(feedDetailRepository: FeedDetailRepository, feedId: Int) {
        self.feedDetailRepository = feedDetailRepository
        self.feedId = feedId
    }
    
    struct Input {
        let backButtonTapped: ControlEvent<Void>
        let replyCollectionViewContentSize: Observable<CGSize?>
        let likeButtonTapped: ControlEvent<Void>
        
        // 작품 연결
        let linkNovelViewTapped: Observable<UITapGestureRecognizer>
        
        // 댓글 작성
        let viewDidTap: Observable<UITapGestureRecognizer>
        let commentContentUpdated: Observable<String>
        let commentContentViewDidBeginEditing: ControlEvent<Void>
        let commentContentViewDidEndEditing: ControlEvent<Void>
        let replyCommentCollectionViewSwipeGesture: Observable<UISwipeGestureRecognizer>
        let sendButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let feedData: Observable<Feed>
        let commentsData: Driver<[FeedComment]>
        let replyCollectionViewHeight: Driver<CGFloat>
        let likeCount: Driver<Int>
        let likeButtonEnabled: Driver<Bool>
        let backButtonEnabled: Driver<Void>
        
        // 작품 연결
        let presentNovelDetailViewController: Observable<Int>
        
        // 댓글 작성
        let commentCount: Driver<Int>
        let showPlaceholder: Observable<Bool>
        let endEditing: Observable<Bool>
        let commentContentWithLengthLimit: Observable<String>
        let sendButtonEnabled: Observable<Bool>
        let textViewEmpty: Observable<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        getSingleFeed(feedId)
            .subscribe(with: self, onNext: { owner, data in
                owner.feedData.onNext(data)
                owner.likeButtonState.accept(data.isLiked)
                owner.likeCount.accept(data.likeCount)
                owner.novelId = data.novelId
                owner.commentCount.accept(data.commentCount)
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
        
        let backButtonEnabled = input.backButtonTapped.asDriver()
        
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
        
        input.linkNovelViewTapped
            .subscribe(with: self, onNext: { owner, _ in
                if let novelId = owner.novelId {
                    owner.presentNovelDetailViewController.accept(novelId)
                }
            })
            .disposed(by: disposeBag)
        
        input.viewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.endEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.commentContentUpdated
            .subscribe(with: self, onNext: { owner, comment in
                if comment.count <= owner.maximumCommentContentCount {
                    owner.updatedCommentContent = comment
                }
                let limitedComment = String(comment.prefix(owner.maximumCommentContentCount))
                owner.commentContentWithLengthLimit.accept(limitedComment)
                
                let isEmpty = comment.count == 0
                let isOverLimit = comment.count > owner.maximumCommentContentCount
                
                owner.isValidCommentContent = !(isEmpty || isOverLimit)
                owner.textViewEmpty.accept(isEmpty)
                owner.showPlaceholder.accept(isEmpty)
                owner.sendButtonEnabled.accept(owner.isValidCommentContent)
            })
            .disposed(by: disposeBag)
        
        input.commentContentViewDidBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.showPlaceholder.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.commentContentViewDidEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.showPlaceholder.accept(owner.updatedCommentContent.count == 0 ? true : false)
            })
            .disposed(by: disposeBag)
        
        input.replyCommentCollectionViewSwipeGesture
            .subscribe(with: self, onNext: { owner, _ in
                owner.endEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.sendButtonTapped
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { () -> Observable<Void> in
                return self.postComment(self.feedId, self.updatedCommentContent)
                    .flatMapLatest { _ in
                        self.getSingleFeedComments(self.feedId)
                            .do(onNext: { newComments in
                                self.commentsData.accept(newComments.comments)
                            })
                            .map { _ in () }
                    }
                    .observe(on: MainScheduler.instance)
                    .do(onNext: {
                        self.updatedCommentContent = ""
                        self.textViewEmpty.accept(true)
                        self.commentContentWithLengthLimit.accept("")
                        self.showPlaceholder.accept(true)
                        
                        let newCommentCount = self.commentCount.value + 1
                        self.commentCount.accept(newCommentCount)
                    })
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(feedData: feedData.asObservable(),
                      commentsData: commentsData.asDriver(),
                      replyCollectionViewHeight: replyCollectionViewContentSize,
                      likeCount: likeCount.asDriver(),
                      likeButtonEnabled: likeButtonState.asDriver(),
                      backButtonEnabled: backButtonEnabled,
                      presentNovelDetailViewController: presentNovelDetailViewController.asObservable(),
                      commentCount: commentCount.asDriver(),
                      showPlaceholder: showPlaceholder.asObservable(),
                      endEditing: endEditing.asObservable(),
                      commentContentWithLengthLimit: commentContentWithLengthLimit.asObservable(),
                      sendButtonEnabled: sendButtonEnabled.asObservable(),
                      textViewEmpty: textViewEmpty.asObservable())
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
    
    func postComment(_ feedId: Int, _ commentContent: String) -> Observable<Void> {
        return feedDetailRepository.postComment(feedId: feedId, commentContent: commentContent)
    }
    
    func putComment(_ feedId: Int, commentId: Int, commentContent: String) -> Observable<Void> {
        return feedDetailRepository.putComment(feedId: feedId, commentId: commentId, commentContent: commentContent)
    }
    
    func deleteComment(_ feedId: Int, commentId: Int) -> Observable<Void> {
        return feedDetailRepository.deleteComment(feedId: feedId, commentId: commentId)
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
