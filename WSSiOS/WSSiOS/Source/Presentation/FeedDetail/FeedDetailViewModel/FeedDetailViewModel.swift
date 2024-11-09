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
    let commentsData = BehaviorRelay<[FeedComment]>(value: [])
    private let replyCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    
    // 작품 연결
    private var novelId: Int?
    private let presentNovelDetailViewController = PublishRelay<Int>()
    
    // 관심 버튼
    private let likeCount = BehaviorRelay<Int>(value: 0)
    private let likeButtonState = BehaviorRelay<Bool>(value: false)
    
    // 댓글 작성
    let commentCount = BehaviorRelay<Int>(value: 0)
    private let endEditing = PublishRelay<Bool>()
    private var updatedCommentContent: String = ""
    private var isValidCommentContent: Bool = false
    private let maximumCommentContentCount: Int = 500
    private let commentContentWithLengthLimit = BehaviorRelay<String>(value: "")
    private let showPlaceholder = BehaviorRelay<Bool>(value: true)
    private let sendButtonEnabled = BehaviorRelay<Bool>(value: false)
    private let textViewEmpty = BehaviorRelay<Bool>(value: true)
    
    // 피드 드롭다운
    private let showDropdownView = BehaviorRelay<Bool>(value: false)
    private let isMyFeed = BehaviorRelay<Bool>(value: false)
    
    let showSpoilerAlertView = PublishRelay<Void>()
    let showImproperAlertView = PublishRelay<Void>()
    let pushToFeedEditViewController = PublishRelay<Void>()
    let showDeleteAlertView = PublishRelay<Void>()
    
    // 댓글 드롭다운
    var selectedCommentId: Int?
    var selectedCommentContent: String?
    let showCommentSpoilerAlertView = PublishRelay<Void>()
    let showCommentImproperAlertView = PublishRelay<Void>()
    let myCommentEditing = PublishRelay<Void>()
    let showCommentDeleteAlertView = PublishRelay<Void>()
    
    //MARK: - Life Cycle
    
    init(feedDetailRepository: FeedDetailRepository, feedId: Int) {
        self.feedDetailRepository = feedDetailRepository
        self.feedId = feedId
    }
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let replyCollectionViewContentSize: Observable<CGSize?>
        let likeButtonDidTap: ControlEvent<Void>
        
        // 작품 연결
        let linkNovelViewDidTap: Observable<UITapGestureRecognizer>
        
        // 댓글 작성
        let viewDidTap: Observable<UITapGestureRecognizer>
        let commentContentUpdated: Observable<String>
        let commentContentViewDidBeginEditing: ControlEvent<Void>
        let commentContentViewDidEndEditing: ControlEvent<Void>
        let replyCommentCollectionViewSwipeGesture: Observable<UISwipeGestureRecognizer>
        let sendButtonDidTap: ControlEvent<Void>
        
        // 피드 드롭다운
        let dotsButtonDidTap: ControlEvent<Void>
        let dropdownButtonDidTap: Observable<DropdownButtonType>
    }
    
    struct Output {
        let feedData: Observable<Feed>
        let commentsData: Driver<[FeedComment]>
        let popViewController: Driver<Void>
        let replyCollectionViewHeight: Driver<CGFloat>
        
        // 관심 버튼
        let likeCount: Driver<Int>
        let likeButtonToggle: Driver<Bool>
        
        // 작품 연결
        let presentNovelDetailViewController: Observable<Int>
        
        // 댓글 작성
        let commentCount: Driver<Int>
        let showPlaceholder: Observable<Bool>
        let endEditing: Observable<Bool>
        let commentContentWithLengthLimit: Observable<String>
        let sendButtonEnabled: Observable<Bool>
        let textViewEmpty: Observable<Bool>
        
        // 피드 드롭다운
        let showDropdownView: Driver<Bool>
        let isMyFeed: Driver<Bool>
        let showSpoilerAlertView: Observable<Void>
        let showImproperAlertView: Observable<Void>
        let pushToFeedEditViewController: Observable<Void>
        let showDeleteAlertView: Observable<Void>
        
        // 댓글 드롭다운
        let showCommentSpoilerAlertView: Observable<Void>
        let showCommentImproperAlertView: Observable<Void>
        let myCommentEditing: Observable<Void>
        let showCommentDeleteAlertView: Observable<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        getSingleFeed(feedId)
            .subscribe(with: self, onNext: { owner, data in
                owner.feedData.onNext(data)
                owner.likeButtonState.accept(data.isLiked)
                owner.likeCount.accept(data.likeCount)
                owner.novelId = data.novelId
                owner.commentCount.accept(data.commentCount)
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
        
        let popViewController = input.backButtonDidTap.asDriver()
        
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
        
        input.linkNovelViewDidTap
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
        
        input.sendButtonDidTap
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
                      popViewController: popViewController,
                      replyCollectionViewHeight: replyCollectionViewContentSize,
                      likeCount: likeCount.asDriver(),
                      likeButtonToggle: likeButtonState.asDriver(),
                      presentNovelDetailViewController: presentNovelDetailViewController.asObservable(),
                      commentCount: commentCount.asDriver(),
                      showPlaceholder: showPlaceholder.asObservable(),
                      endEditing: endEditing.asObservable(),
                      commentContentWithLengthLimit: commentContentWithLengthLimit.asObservable(),
                      sendButtonEnabled: sendButtonEnabled.asObservable(),
                      textViewEmpty: textViewEmpty.asObservable(),
                      showDropdownView: showDropdownView.asDriver(),
                      isMyFeed: isMyFeed.asDriver(),
                      showSpoilerAlertView: showSpoilerAlertView.asObservable(),
                      showImproperAlertView: showImproperAlertView.asObservable(),
                      pushToFeedEditViewController: pushToFeedEditViewController.asObservable(),
                      showDeleteAlertView: showDeleteAlertView.asObservable(),
                      showCommentSpoilerAlertView: showCommentSpoilerAlertView.asObservable(),
                      showCommentImproperAlertView: showCommentImproperAlertView.asObservable(),
                      myCommentEditing: myCommentEditing.asObservable(),
                      showCommentDeleteAlertView: showCommentDeleteAlertView.asObservable())
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
    
    func postComment(_ feedId: Int, _ commentContent: String) -> Observable<Void> {
        return feedDetailRepository.postComment(feedId: feedId, commentContent: commentContent)
    }
    
    func putComment(_ feedId: Int, commentId: Int, commentContent: String) -> Observable<Void> {
        return feedDetailRepository.putComment(feedId: feedId, commentId: commentId, commentContent: commentContent)
    }
    
    func deleteComment(_ feedId: Int, commentId: Int) -> Observable<Void> {
        return feedDetailRepository.deleteComment(feedId: feedId, commentId: commentId)
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
    
    func postSpoilerComment(_ feedId: Int,_ commentId: Int) -> Observable<Void> {
        return feedDetailRepository.postSpoilerComment(feedId: feedId, commentId: commentId)
    }
    
    func postImpertinenceComment(_ feedId: Int,_ commentId: Int) -> Observable<Void> {
        return feedDetailRepository.postImpertinenceComment(feedId: feedId, commentId: commentId)
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
