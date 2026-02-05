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
    private let userRepository: UserInfoRepository
    private let disposeBag = DisposeBag()
    
    let feedId: Int
    private let feedData = PublishSubject<FeedEntity>()
    let commentsData = BehaviorRelay<[FeedCommentEntity]>(value: [])
    private let myProfileData = PublishRelay<MyProfileEntity>()
    private let replyCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    private var feedUserId: Int?
    
    // 첨부 이미지
    private var imageURLs: [URL?] = []
    private let presentToFeedDetailAddImageViewerViewController = PublishRelay<(Int, [URL?])>()
    
    // 관심 버튼
    private let likeCount = BehaviorRelay<Int>(value: 0)
    private let likeButtonState = BehaviorRelay<Bool>(value: false)
    
    // 작품 연결
    private var novelId: Int?
    private let presentNovelDetailViewController = PublishRelay<Int>()
    
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
    private let sendCommentState = BehaviorRelay<SendCommentState>(value: .idle)
    private let showNetworkErrorToastView = BehaviorRelay<Bool>(value: false)
    
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
    let myCommentEditing = PublishRelay<String>()
    let showCommentDeleteAlertView  = PublishRelay<((Int, Int) -> Observable<Void>, Int, Int)>()
    let showWithdrawalUserToastView = PublishRelay<Void>()
    
    let pushToUserPageViewController = PublishRelay<Int>()
    private let showLoadingView = PublishRelay<Bool>()
    private let showNetworkErrorView = PublishRelay<Void>()
    private let showUnknownFeedAlertView = PublishRelay<Void>()
    private let popViewController = PublishRelay<Void>()
    
    //MARK: - Life Cycle
    
    init(feedDetailRepository: FeedDetailRepository,
         userRepository: UserInfoRepository,
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
        
        // 첨부 이미지
        let imageViewDidTap: Observable<Int>
        
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
        
        let popFeedDetailViewControllerNotification: Observable<Notification>
    }
    
    struct Output {
        let feedData: Observable<FeedEntity>
        let commentsData: Driver<[FeedCommentEntity]>
        let myProfileData: Observable<MyProfileEntity>
        let popViewController: Observable<Void>
        let replyCollectionViewHeight: Driver<CGFloat>
        
        // 첨부 이미지
        let presentFeedDetailAddImageViewerController: Observable<(Int, [URL?])>
        
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
        let sendCommentState: Observable<SendCommentState>
        let showNetworkErrorToastView: Observable<Bool>
        
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
        let myCommentEditing: Observable<String>
        let showCommentDeleteAlertView: Observable<((Int, Int) -> Observable<Void>, Int, Int)>
        let showWithdrawalUserToastView: Observable<Void>
        
        let pushToUserPageViewController: Observable<Int>
        let showLoadingView: Observable<Bool>
        let showNetworkErrorView: Observable<Void>
        let showUnknownFeedAlertView: Observable<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppearEvent
            .flatMapLatest {
                self.getSingleFeed(self.feedId)
                    .asObservable()
                    .materialize()
            }
            .subscribe(with: self, onNext: { owner, event in
                switch event {
                case .next(let feed):
                    owner.feedData.onNext(feed)
                    owner.likeButtonState.accept(feed.isLiked)
                    owner.likeCount.accept(feed.likeCount)
                    owner.feedUserId = feed.userId
                    owner.novelId = feed.novelData?.novelId
                    owner.commentCount.accept(feed.commentCount)
                    owner.isMyFeed.accept(feed.isMyFeed)
                    owner.imageURLs = feed.imageURLs
                case .error(let error):
                    owner.handleNetworkError(error)
                case .completed:
                    break
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
        
        input.backButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        let replyCollectionViewContentSize = input.replyCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        input.likeButtonDidTap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .withLatestFrom(likeButtonState)
            .flatMapLatest { isLiked -> Observable<Void> in
                
                // UI 반영
                let newLikedState = !isLiked
                self.likeButtonState.accept(newLikedState)
                let newCount = newLikedState ? self.likeCount.value + 1 : self.likeCount.value - 1
                self.likeCount.accept(newCount)
                HapticManager.shared.generateImpactFeedback(style: .light)
                
                // 서버 전송
                let request: Observable<Void> = newLikedState
                ? self.postFeedLike(self.feedId)
                    .do(onNext: { _ in
                        AmplitudeManager.shared.track(AmplitudeEvent.Feed.feedDetailLike)
                    })
                : self.deleteFeedLike(self.feedId)
                
                return request
                    .catch { error in
                        self.likeButtonState.accept(isLiked)
                        self.likeCount.accept(self.likeCount.value + (isLiked ? 1 : -1))
                        return .empty()
                    }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        input.userProfileViewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                guard let feedUserId = owner.feedUserId else { return }
                if !owner.isMyFeed.value && feedUserId != -1 {
                    owner.pushToUserPageViewController.accept(feedUserId)
                } else if feedUserId == -1 {
                    owner.showWithdrawalUserToastView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        // 첨부 이미지
        input.imageViewDidTap
            .subscribe(with: self, onNext: { owner, index in
                owner.presentToFeedDetailAddImageViewerViewController.accept((index, owner.imageURLs))
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
        
        // MARK: - 댓글 작성
        
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
        
        // MARK: - 댓글 전송
        
        let sendCommentRequest = input.sendButtonDidTap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .filter { owner, _ in owner.isValidCommentContent }
            .map { owner, _ -> SendCommentRequest in
                let mode: SendCommentRequest.Mode =
                owner.isCommentEditing
                ? .edit(commentId: owner.selectedCommentId)
                : .create
                
                owner.sendButtonEnabled.accept(false)
                
                return SendCommentRequest(
                    content: owner.updatedCommentContent,
                    mode: mode
                )
            }
            .share()
        
        let sendCommentState = sendCommentRequest
            .flatMapLatest { [weak self] request -> Observable<SendCommentState> in
                guard let self else { return .empty() }
                
                return self.sendComment(request: request)
                    .flatMapLatest {
                        self.getSingleFeedComments(self.feedId)
                    }
                    .timeout(.seconds(10), scheduler: MainScheduler.instance)
                    .map { SendCommentState.success($0.comments) }
                    .startWith(.loading)
                    .catch { error in
                            .just(.failure(error))
                    }
            }
            .startWith(.idle)
            .share()
        
        sendCommentState
            .compactMap { state -> [FeedCommentEntity]? in
                if case let .success(comments) = state {
                    return comments
                }
                return nil
            }
            .bind(to: commentsData)
            .disposed(by: disposeBag)

        sendCommentState
            .filter {
                if case .success = $0 { return true }
                return false
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.isCommentEditing = false
                owner.selectedCommentId = 0
                owner.initialCommentContent = ""
                owner.updatedCommentContent = ""
                
                owner.textViewEmpty.accept(true)
                owner.showPlaceholder.accept(true)
                owner.textViewResignFirstResponder.accept(())
            })
            .disposed(by: disposeBag)
        
        sendCommentState
            .compactMap {
                if case let .failure(error) = $0 {
                    return error
                }
                return nil
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.showNetworkErrorToastView.accept(true)
                owner.sendButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        // MARK: - 피드 드롭다운
        
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
        
        // MARK: - 댓글 드롭다운
        
        input.profileViewDidTap
            .subscribe(with: self, onNext: { owner, data in
                let (commentId, commentUserId ,isMyComment) = data
                if owner.commentsData.value.firstIndex(where: { $0.commentId == commentId }) != nil {
                    if !isMyComment && commentUserId != -1 {
                        owner.pushToUserPageViewController.accept(commentUserId)
                    } else if commentUserId == -1 {
                        // 탈퇴 유저일 때
                        owner.showWithdrawalUserToastView.accept(())
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
                    // 댓글 수정하기
                    owner.isCommentEditing = true
                    
                    if let index = owner.commentsData.value.firstIndex(
                        where: { $0.commentId == owner.selectedCommentId }
                    ) {
                        let initialContent = owner.commentsData.value[index].commentContent
                        owner.myCommentEditing.accept(initialContent)
                        owner.initialCommentContent = initialContent
                    }
                case (.bottom, true):
                    // 댓글 삭제하기
                    owner.showCommentDeleteAlertView.accept((owner.deleteComment,
                                                             owner.feedId,
                                                             owner.selectedCommentId))
                case (.top, false):
                    // 스포일러 댓글 신고하기
                    owner.showCommentSpoilerAlertView.accept((owner.postSpoilerComment,
                                                              owner.feedId,
                                                              owner.selectedCommentId))
                case (.bottom, false):
                    // 부적절한 댓글 신고하기
                    owner.showCommentImpertinenceAlertView.accept((owner.postImpertinenceComment,
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
        
        input.popFeedDetailViewControllerNotification
            .subscribe(with: self, onNext: { owner, notification in
                owner.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(feedData: feedData.asObservable(),
                      commentsData: commentsData.asDriver(),
                      myProfileData: myProfileData.asObservable(),
                      popViewController: popViewController.asObservable(),
                      replyCollectionViewHeight: replyCollectionViewContentSize,
                      presentFeedDetailAddImageViewerController: presentToFeedDetailAddImageViewerViewController.asObservable(),
                      likeCount: likeCount.asDriver(),
                      likeButtonToggle: likeButtonState.asDriver(),
                      presentNovelDetailViewController: presentNovelDetailViewController.asObservable(),
                      commentCount: commentCount.asDriver(),
                      showPlaceholder: showPlaceholder.asObservable(),
                      endEditing: endEditing.asObservable(),
                      textViewResignFirstResponder: textViewResignFirstResponder.asObservable(),
                      sendButtonEnabled: sendButtonEnabled.asObservable(),
                      textViewEmpty: textViewEmpty.asObservable(),
                      sendCommentState: sendCommentState.asObservable(),
                      showNetworkErrorToastView: showNetworkErrorToastView.asObservable(),
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
                      showWithdrawalUserToastView: showWithdrawalUserToastView.asObservable(),
                      pushToUserPageViewController: pushToUserPageViewController.asObservable(),
                      showLoadingView: showLoadingView.asObservable(),
                      showNetworkErrorView: showNetworkErrorView.asObservable(),
                      showUnknownFeedAlertView: showUnknownFeedAlertView.asObservable())
    }
    
    //MARK: - API
    
    private func sendComment(request: SendCommentRequest) -> Observable<Void> {
        switch request.mode {
        case .create:
            return postComment(feedId, request.content)
            
        case .edit(let commentId):
            return putComment(feedId, commentId, request.content)
        }
    }
    
    func getSingleFeed(_ feedId: Int) -> Observable<FeedEntity> {
        return feedDetailRepository.getSingleFeedData(feedId: feedId)
    }
    
    func getSingleFeedComments(_ feedId: Int) -> Observable<FeedCommentsEntity> {
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
    
    func getMyProfile() -> Observable<MyProfileEntity> {
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
    
    private func handleNetworkError(_ error: Error) {
        guard let networkError = error as? RxCocoaURLError else {
            self.showNetworkErrorView.accept(())
            return
        }
        
        if case .httpRequestFailed(_, let data) = networkError,
           let data,
           let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
            handleUnknownFeedError(errorResponse)
        } else {
            showNetworkErrorView.accept(())
        }
    }
    
    private func handleUnknownFeedError(_ errorResponse: ServerErrorResponse) {
        let alertCodes = ["FEED-001", "FEED-005", "FEED-006"]
        if alertCodes.contains(errorResponse.code) {
            showUnknownFeedAlertView.accept(())
        } else {
            showNetworkErrorView.accept(())
        }
    }

    private struct SendCommentRequest {
        let content: String
        let mode: Mode
        
        enum Mode {
            case create
            case edit(commentId: Int)
        }
    }
    
    enum SendCommentState {
        case idle
        case loading
        case success([FeedCommentEntity])
        case failure(Error)
    }
}

enum DropdownButtonType {
    case top
    case bottom
}
