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
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    
    let feedId: Int
    private let feedData = PublishSubject<Feed>()
    let commentsData = BehaviorRelay<[FeedComment]>(value: [])
    private let myProfileData = PublishRelay<MyProfileResult>()
    private let replyCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    private var feedUserId: Int?
    
    // 작품 연결
    private var novelId: Int?
    private let presentNovelDetailViewController = PublishRelay<Int>()
    
    // 관심 버튼
    private let likeCount = BehaviorRelay<Int>(value: 0)
    private let likeButtonState = BehaviorRelay<Bool>(value: false)
    
    // 댓글 작성
    let commentCount = BehaviorRelay<Int>(value: 0)
    private let endEditing = PublishRelay<Bool>()
    private let textViewResignFirstResponder = PublishRelay<Void>()
    var initialCommentContent: String = ""
    private var updatedCommentContent: String = ""
    private var isValidCommentContent: Bool = false
    private let showPlaceholder = BehaviorRelay<Bool>(value: true)
    private let sendButtonEnabled = BehaviorRelay<Bool>(value: false)
    private let textViewEmpty = BehaviorRelay<Bool>(value: true)
    
    // 피드 드롭다운
    private let showDropdownView = BehaviorRelay<Bool>(value: false)
    private let isMyFeed = BehaviorRelay<Bool>(value: false)
    
    let showSpoilerAlertView = PublishRelay<Void>()
    let showImpertinenceAlertView = PublishRelay<Void>()
    let pushToFeedEditViewController = PublishRelay<Void>()
    let showDeleteAlertView = PublishRelay<Void>()
    
    // 댓글 드롭다운
    var selectedCommentId: Int = 0
    var selectedCommentContent: String = ""
    private var isMyComment: Bool = false
    private let showCommentDropdownView = PublishRelay<(IndexPath, Bool)>()
    private let hideCommentDropdownView = PublishRelay<Void>()
    private let toggleDropdownView = PublishRelay<Void>()
    // 댓글 드롭다운 내 이벤트
    let showCommentSpoilerAlertView  = PublishRelay<((Int, Int) -> Observable<Void>, Int, Int)>()
    let showCommentImpertinenceAlertView  = PublishRelay<((Int, Int) -> Observable<Void>, Int, Int)>()
    var isCommentEditing: Bool = false
    let myCommentEditing = PublishRelay<Void>()
    let showCommentDeleteAlertView  = PublishRelay<((Int, Int) -> Observable<Void>, Int, Int)>()
    
    let pushToUserPageViewController = PublishRelay<Int>()
    private let showLoadingView = PublishRelay<Bool>()
    private let showNetworkErrorView = PublishRelay<Void>()
    private let showUnknownUserAlertView = PublishRelay<Void>()
    
    //MARK: - Life Cycle
    
    init(feedDetailRepository: FeedDetailRepository,
         userRepository: UserRepository,
         feedId: Int) {
        self.feedDetailRepository = feedDetailRepository
        self.userRepository = userRepository
        self.feedId = feedId
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        
        let backButtonDidTap: ControlEvent<Void>
        let replyCollectionViewContentSize: Observable<CGSize?>
        let likeButtonDidTap: Observable<UITapGestureRecognizer>
        let userProfileViewDidTap: Observable<UITapGestureRecognizer>
        
        // 작품 연결
        let linkNovelViewDidTap: Observable<UITapGestureRecognizer>
        
        // 댓글 작성
        let viewDidTap: Observable<UITapGestureRecognizer>
        let commentContentUpdated: Observable<String>
        let commentContentViewDidBeginEditing: ControlEvent<Void>
        let commentContentViewDidEndEditing: ControlEvent<Void>
        let replyCommentCollectionViewSwipeGesture: Observable<UISwipeGestureRecognizer>
        let sendButtonDidTap: ControlEvent<Void>
        let commentSpoilerTextDidTap: Observable<Void>
        
        // 피드 드롭다운
        let dotsButtonDidTap: ControlEvent<Void>
        let dropdownButtonDidTap: Observable<DropdownButtonType>
        let backgroundViewDidTap: ControlEvent<UITapGestureRecognizer>
        
        // 댓글 드롭다운
        let profileViewDidTap: Observable<(Int, Int, Bool)>
        let commentdotsButtonDidTap: Observable<(Int, Bool)>
        let commentDropdownDidTap: Observable<DropdownButtonType>
        let reloadComments: Observable<Void>
    }
    
    struct Output {
        let feedData: Observable<Feed>
        let commentsData: Driver<[FeedComment]>
        let myProfileData: Observable<MyProfileResult>
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
        let textViewResignFirstResponder: Observable<Void>
        let sendButtonEnabled: Observable<Bool>
        let textViewEmpty: Observable<Bool>
        
        // 피드 드롭다운
        let showDropdownView: Driver<Bool>
        let isMyFeed: Driver<Bool>
        // 피드 드롭다운 내 이벤트
        let showSpoilerAlertView: Observable<Void>
        let showImpertinenceAlertView: Observable<Void>
        let pushToFeedEditViewController: Observable<Void>
        let showDeleteAlertView: Observable<Void>
        
        // 댓글 드롭다운
        let showCommentDropdownView: Observable<(IndexPath, Bool)>
        let hideCommentDropdownView: Observable<Void>
        let toggleDropdownView: Observable<Void>
        // 댓글 드롭다운 내 이벤트
        let showCommentSpoilerAlertView: Observable<((Int, Int) -> Observable<Void>, Int, Int)>
        let showCommentImpertinenceAlertView: Observable<((Int, Int) -> Observable<Void>, Int, Int)>
        let myCommentEditing: Observable<Void>
        let showCommentDeleteAlertView: Observable<((Int, Int) -> Observable<Void>, Int, Int)>
        
        let pushToUserPageViewController: Observable<Int>
        let showLoadingView: Observable<Bool>
        let showNetworkErrorView: Observable<Void>
        let showUnknownUserAlertView: Observable<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest { self.getSingleFeed(self.feedId) }
            .subscribe(with: self, onNext: { owner, feed in
                owner.feedData.onNext(feed)
                owner.likeButtonState.accept(feed.isLiked)
                owner.likeCount.accept(feed.likeCount)
                owner.feedUserId = feed.userId
                owner.novelId = feed.novelId
                owner.commentCount.accept(feed.commentCount)
                owner.isMyFeed.accept(feed.isMyFeed)
            }, onError: { owner, error in
                guard let networkError = error as? RxCocoaURLError else {
                    owner.showNetworkErrorView.accept(())
                    return
                }
                switch networkError {
                case .httpRequestFailed(_, let data):
                    if let data,
                       let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                        if errorResponse.code == "FEED-001" {
                            owner.showUnknownUserAlertView.accept(())
                        }
                    } else {
                        owner.showNetworkErrorView.accept(())
                    }
                default: owner.showNetworkErrorView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .do(onNext: {
                self.showLoadingView.accept(true)
            })
            .flatMapLatest { _ in
                Observable.zip(
                    self.getSingleFeedComments(self.feedId),
                    self.getMyProfile()
                )
            }
            .subscribe(with: self, onNext: { owner, data in
                let comments = data.0
                let profile = data.1

                owner.commentsData.accept(comments.comments)
                owner.myProfileData.accept(profile)
                
                owner.showLoadingView.accept(false)
            }, onError: { owner, error in
                print(error)
                owner.showLoadingView.accept(false)
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
        
        input.userProfileViewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                guard let feedUserId = owner.feedUserId else { return }
                if !owner.isMyFeed.value {
                    owner.pushToUserPageViewController.accept(feedUserId)
                }
            })
            .disposed(by: disposeBag)
        
        // 작품 연결
        input.linkNovelViewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                if let novelId = owner.novelId {
                    owner.presentNovelDetailViewController.accept(novelId)
                }
            })
            .disposed(by: disposeBag)
        
        // 댓글 작성
        input.viewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.endEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.commentContentUpdated
            .subscribe(with: self, onNext: { owner, comment in
                owner.updatedCommentContent = comment
                
                let isEmpty = comment.isEmpty
                let containsOnlyNewlinesOrWhitespace = comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let isNotChanged = comment == owner.initialCommentContent
                
                owner.isValidCommentContent = !(containsOnlyNewlinesOrWhitespace || isNotChanged)
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
                if self.isCommentEditing {
                    return self.putComment(self.feedId,
                                           self.selectedCommentId,
                                           self.updatedCommentContent)
                    .flatMapLatest { _ in
                        self.getSingleFeedComments(self.feedId)
                            .do(onNext: { _ in
                                self.showLoadingView.accept(true)
                            })
                            .do(onNext: { newComments in
                                self.commentsData.accept(newComments.comments)
                            })
                            .map { _ in () }
                    }
                    .do(onNext: {
                        self.textViewResignFirstResponder.accept(())
                        self.updatedCommentContent = ""
                        self.textViewEmpty.accept(true)
                        self.showPlaceholder.accept(true)
                        self.isCommentEditing = false
                        self.selectedCommentId = 0
                        self.showLoadingView.accept(false)
                    })
                } else {
                    return self.postComment(self.feedId, self.updatedCommentContent)
                        .flatMapLatest { _ in
                            self.getSingleFeedComments(self.feedId)
                                .do(onNext: { _ in
                                    self.showLoadingView.accept(true)
                                })
                                .do(onNext: { newComments in
                                    self.commentsData.accept(newComments.comments)
                                })
                                .map { _ in () }
                        }
                        .do(onNext: {
                            self.textViewResignFirstResponder.accept(())
                            self.updatedCommentContent = ""
                            self.textViewEmpty.accept(true)
                            self.showPlaceholder.accept(true)
                            self.selectedCommentId = 0
                            self.showLoadingView.accept(false)
                            
                            let newCommentCount = self.commentCount.value + 1
                            self.commentCount.accept(newCommentCount)
                        })
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        // 피드 드롭다운
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
                case (.bottom, false): owner.showImpertinenceAlertView.accept(())
                }
                owner.showDropdownView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.backgroundViewDidTap
            .bind(with: self, onNext: { owner, _ in
                owner.showDropdownView.accept(false)
                owner.hideCommentDropdownView.accept(())
            })
            .disposed(by: disposeBag)
        
        // 댓글 드롭다운
        input.profileViewDidTap
            .subscribe(with: self, onNext: { owner, data in
                let (commentId, commentUserId ,isMyComment) = data
                if owner.commentsData.value.firstIndex(where: { $0.commentId == commentId }) != nil {
                    if !isMyComment {
                        owner.pushToUserPageViewController.accept(commentUserId)
                    }
                }
                owner.selectedCommentId = commentId
                owner.isMyComment = isMyComment
            })
            .disposed(by: disposeBag)
        
        input.commentdotsButtonDidTap
            .subscribe(with: self, onNext: { owner, data in
                let (commentId, isMyComment) = data
                if owner.selectedCommentId == commentId {
                    owner.toggleDropdownView.accept(())
                } else {
                    if let index = owner.commentsData.value.firstIndex(where: { $0.commentId == commentId }) {
                        let indexPath = IndexPath(row: index, section: 0)
                        owner.showCommentDropdownView.accept((indexPath, isMyComment))
                        owner.initialCommentContent = owner.commentsData.value[index].commentContent
                    }
                }
                owner.selectedCommentId = commentId
                owner.isMyComment = isMyComment
            })
            .disposed(by: disposeBag)
        
        input.commentDropdownDidTap
            .map { ($0, self.isMyComment) }
            .subscribe(with: self, onNext: { owner, result in
                owner.hideCommentDropdownView.accept(())
                switch result {
                case (.top, true):
                    owner.isCommentEditing = true
                    owner.myCommentEditing.accept(())
                case (.bottom, true):
                    owner.showCommentDeleteAlertView.accept((owner.deleteComment,
                                                             owner.feedId,
                                                             owner.selectedCommentId))
                case (.top, false): owner.showCommentSpoilerAlertView.accept((owner.postSpoilerComment,
                                                                              owner.feedId,
                                                                              owner.selectedCommentId))
                case (.bottom, false): owner.showCommentImpertinenceAlertView.accept((owner.postImpertinenceComment,
                                                                                      owner.feedId,
                                                                                      owner.selectedCommentId))
                }
            })
            .disposed(by: disposeBag)
        
        input.reloadComments
            .do(onNext: {
                self.showLoadingView.accept(true)
            })
            .flatMapLatest {
                return self.getSingleFeedComments(self.feedId)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.commentsData.accept(data.comments)
                owner.showLoadingView.accept(false)
            }, onError: { owner, error in
                print(error)
                owner.showLoadingView.accept(false)
            })
            .disposed(by: disposeBag)
        
        return Output(feedData: feedData.asObservable(),
                      commentsData: commentsData.asDriver(),
                      myProfileData: myProfileData.asObservable(),
                      popViewController: popViewController,
                      replyCollectionViewHeight: replyCollectionViewContentSize,
                      likeCount: likeCount.asDriver(),
                      likeButtonToggle: likeButtonState.asDriver(),
                      presentNovelDetailViewController: presentNovelDetailViewController.asObservable(),
                      commentCount: commentCount.asDriver(),
                      showPlaceholder: showPlaceholder.asObservable(),
                      endEditing: endEditing.asObservable(),
                      textViewResignFirstResponder: textViewResignFirstResponder.asObservable(),
                      sendButtonEnabled: sendButtonEnabled.asObservable(),
                      textViewEmpty: textViewEmpty.asObservable(),
                      showDropdownView: showDropdownView.asDriver(),
                      isMyFeed: isMyFeed.asDriver(),
                      showSpoilerAlertView: showSpoilerAlertView.asObservable(),
                      showImpertinenceAlertView: showImpertinenceAlertView.asObservable(),
                      pushToFeedEditViewController: pushToFeedEditViewController.asObservable(),
                      showDeleteAlertView: showDeleteAlertView.asObservable(),
                      showCommentDropdownView: showCommentDropdownView.asObservable(),
                      hideCommentDropdownView: hideCommentDropdownView.asObservable(),
                      toggleDropdownView: toggleDropdownView.asObservable(),
                      showCommentSpoilerAlertView: showCommentSpoilerAlertView.asObservable(),
                      showCommentImpertinenceAlertView: showCommentImpertinenceAlertView.asObservable(),
                      myCommentEditing: myCommentEditing.asObservable(),
                      showCommentDeleteAlertView: showCommentDeleteAlertView.asObservable(),
                      pushToUserPageViewController: pushToUserPageViewController.asObservable(),
                      showLoadingView: showLoadingView.asObservable(),
                      showNetworkErrorView: showNetworkErrorView.asObservable(),
                      showUnknownUserAlertView: showUnknownUserAlertView.asObservable())
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
            .observe(on: MainScheduler.instance)
    }
    
    func putComment(_ feedId: Int, _ commentId: Int, _ commentContent: String) -> Observable<Void> {
        return feedDetailRepository.putComment(feedId: feedId, commentId: commentId, commentContent: commentContent)
            .observe(on: MainScheduler.instance)
    }
    
    func deleteComment(_ feedId: Int, _ commentId: Int) -> Observable<Void> {
        return feedDetailRepository.deleteComment(feedId: feedId, commentId: commentId)
            .observe(on: MainScheduler.instance)
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
    
    func postSpoilerComment(_ feedId: Int, _ commentId: Int) -> Observable<Void> {
        return feedDetailRepository.postSpoilerComment(feedId: feedId, commentId: commentId)
            .observe(on: MainScheduler.instance)
    }
    
    func postImpertinenceComment(_ feedId: Int, _ commentId: Int) -> Observable<Void> {
        return feedDetailRepository.postImpertinenceComment(feedId: feedId, commentId: commentId)
            .observe(on: MainScheduler.instance)
    }
    
    func getMyProfile() -> Observable<MyProfileResult> {
        return userRepository.getMyProfileData()
            .observe(on: MainScheduler.instance)
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
