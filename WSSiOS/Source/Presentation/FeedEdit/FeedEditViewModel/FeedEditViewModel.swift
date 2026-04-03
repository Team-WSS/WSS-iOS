//
//  FeedEditViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import RxSwift
import RxCocoa

final class FeedEditViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let feedRepository: FeedRepository
    private let feedDetailRepository: FeedDetailRepository
    
    private var isValidFeedContent: Bool = false
    private let feedContentPredicate = NSPredicate(format: "SELF MATCHES %@", "^[\\s]+$")
    private let maximumFeedContentCount: Int = 2000
    
    private let feedId: Int?
    private var newNovelId: Int?
    private var newFeedContent: String = ""
    
    // 기존 피드 수정
    private var initialIsSpoiler: Bool?
    private var initialIsPublic: Bool?
    private var initialNovelId: Int?
    private var initialAddImages: [UIImage]?
    private var isFeedContentChanged: Bool = false
    private var isSpoilerChanged: Bool = false
    private var isPublicChanged: Bool = false
    private var isNovelIdChanged: Bool = false
    private var isAddImagesChanged: Bool = false
    
    // Output
    private let endEditing = PublishRelay<Bool>()
    private let popViewController = PublishRelay<Void>()
    private let initialFeedContent = BehaviorRelay<String>(value: "")
    private let isSpoiler = BehaviorRelay<Bool>(value: false)
    private let isPublic = BehaviorRelay<Bool>(value: true)
    private let feedContentWithLengthLimit = BehaviorRelay<String>(value: "")
    private let completeButtonIsAbled = BehaviorRelay<Bool>(value: false)
    private let showPlaceholder = BehaviorRelay<Bool>(value: true)
    private let presentFeedEditNovelConnectModalViewController = PublishRelay<Void>()
    private let connectedNovelTitle = BehaviorRelay<String?>(value: nil)
    private let showAlreadyConnectedToast = PublishRelay<Void>()
    private let showStopEditingAlert = PublishRelay<Void>()
    private let presentPhotoPicker = PublishRelay<Void>()
    private let showAddImageView = PublishRelay<Bool>()
    private let showLoadingView = PublishRelay<Bool>()
    private let backButtonIsAbled = BehaviorRelay<Bool>(value: false)
    var selectedImages = BehaviorRelay<[UIImage]>(value: [])
    
    //MARK: - Life Cycle
    
    init(feedRepository: FeedRepository,
         feedDetailRepository: FeedDetailRepository,
         feedId: Int? = nil,
         novelId: Int? = nil,
         novelTitle: String? = nil) {
        self.feedRepository = feedRepository
        self.feedDetailRepository = feedDetailRepository
        
        self.feedId = feedId
        self.newNovelId = novelId
        
        self.connectedNovelTitle.accept(novelTitle)
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewDidTap: Observable<UITapGestureRecognizer>
        let backButtonDidTap: ControlEvent<Void>
        let completeButtonDidTap: ControlEvent<Void>
        let spoilerButtonDidTap: ControlEvent<Void>
        let publicButtonDidTap: ControlEvent<Void>
        let feedContentUpdated: Observable<String>
        let feedContentViewDidBeginEditing: ControlEvent<Void>
        let feedContentViewDidEndEditing: ControlEvent<Void>
        let novelConnectViewDidTap: Observable<UITapGestureRecognizer>
        let feedNovelConnectedNotification: Observable<Notification>
        let novelRemoveButtonDidTap: ControlEvent<Void>
        let stopEditButtonDidTap: Observable<Void>
        let photoAddButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let endEditing: Observable<Bool>
        let popViewController: Observable<Void>
        let initialFeedContent: Observable<String>
        let isSpoiler: Observable<Bool>
        let isPublic: Observable<Bool>
        let feedContentWithLengthLimit: Observable<String>
        let completeButtonIsAbled: Observable<Bool>
        let showPlaceholder: Observable<Bool>
        let presentFeedEditNovelConnectModalViewController: Observable<Void>
        let connectedNovelTitle: Observable<String?>
        let showAlreadyConnectedToast: Observable<Void>
        let showStopEditingAlert: Observable<Void>
        let presentPhotoPicker: Observable<Void>
        let showAddImageView: Observable<Bool>
        let selectedImages: Observable<[UIImage]>
        let showLoadingView: Observable<Bool>
        let backButtonIsAbled: Observable<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .map { [weak self] in self?.feedId }
            .flatMapLatest { feedId -> Observable<FeedEntity?> in
                if let feedId = feedId {
                    return self.getSingleFeed(feedId).map { Optional($0) }
                } else {
                    return Observable.just(nil)
                }
            }
            .subscribe(with: self, onNext: { owner, data in
                guard let data = data else { return }
                owner.initialFeedContent.accept(data.feedContent)
                
                owner.initialNovelId = data.novelData?.novelId
                owner.newNovelId = data.novelData?.novelId
                owner.connectedNovelTitle.accept(data.novelData?.novelTitle)
                
                owner.initialIsSpoiler = data.isSpoiler
                owner.isSpoiler.accept(data.isSpoiler)
                
                owner.initialIsPublic = data.isPublic
                owner.isPublic.accept(data.isPublic)
                
                Observable.from(data.imageURLs)
                    .compactMap { $0 }
                    .flatMap { url -> Observable<UIImage> in
                        KingFisherRxHelper.kingFisherImage(url: url)
                            .catchAndReturn(UIImage())
                    }
                    .toArray()
                    .observe(on: MainScheduler.instance)
                    .subscribe(onSuccess: { images in
                        owner.selectedImages.accept(images)
                        owner.initialAddImages = images
                    })
                    .disposed(by: disposeBag)
                
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.viewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.endEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.showStopEditingAlert.accept(())
            })
            .disposed(by: disposeBag)
        
        input.completeButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(self.completeButtonIsAbled)
            .filter { $0 }
            .do(onNext: { _ in
                self.completeButtonIsAbled.accept(false)
                self.backButtonIsAbled.accept(false)
                self.showLoadingView.accept(true)
                AmplitudeManager.shared.track(AmplitudeEvent.Feed.writeFeed)
            })
            .withLatestFrom(Observable.combineLatest(isSpoiler, isPublic, selectedImages))
            .flatMapLatest { (isSpoiler, isPublic, selectedImages) in
                Observable.deferred {
                    if let feedId = self.feedId {
                        self.putFeed(feedId: feedId, feedContent: self.newFeedContent, novelId: self.newNovelId, isSpoiler: isSpoiler, isPublic: isPublic, images: selectedImages)
                    } else {
                        self.postFeed(feedContent: self.newFeedContent, novelId: self.newNovelId, isSpoiler: isSpoiler, isPublic: isPublic, images: selectedImages)
                    }
                }
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            }
            .subscribe(with: self, onNext: { owner, _ in
                owner.showLoadingView.accept(false)
                owner.backButtonIsAbled.accept(true)
                NotificationCenter.default.post(name: NotificationName.feedEdited, object: nil)
                owner.popViewController.accept(())
                AppReviewManager.shared.requestReview()
            }, onError: { owner, error  in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.spoilerButtonDidTap
            .withLatestFrom(isSpoiler)
            .subscribe(with: self, onNext: { owner, isSpoiler in
                owner.isSpoiler.accept(!isSpoiler)
                owner.isSpoilerChanged = owner.initialIsSpoiler != owner.isSpoiler.value
                owner.checkIfCompleteButtonIsAbled()
            })
            .disposed(by: disposeBag)
        
        input.publicButtonDidTap
            .withLatestFrom(isPublic)
            .subscribe(with: self, onNext: { owner, isPublic in
                owner.isPublic.accept(!isPublic)
                owner.isPublicChanged = owner.initialIsPublic != owner.isPublic.value
                owner.checkIfCompleteButtonIsAbled()
            })
            .disposed(by: disposeBag)
        
        input.feedContentUpdated
            .subscribe(with: self, onNext: { owner, text in
                owner.newFeedContent = text
                owner.feedContentWithLengthLimit.accept(String(text.prefix(owner.maximumFeedContentCount)))
                
                let isEmpty = text.count == 0
                let isOverLimit = text.count > owner.maximumFeedContentCount
                let isWrongFormat = owner.feedContentPredicate.evaluate(with: text)
                
                owner.isValidFeedContent = !(isEmpty || isOverLimit || isWrongFormat)
                
                owner.isFeedContentChanged = text != owner.initialFeedContent.value
                
                owner.showPlaceholder.accept(isEmpty)
                owner.checkIfCompleteButtonIsAbled()
            })
            .disposed(by: disposeBag)
        
        input.feedContentViewDidBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.showPlaceholder.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.feedContentViewDidEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.showPlaceholder.accept(owner.newFeedContent.count == 0 ? true : false)
            })
            .disposed(by: disposeBag)
        
        input.novelConnectViewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                if owner.newNovelId != nil {
                    owner.showAlreadyConnectedToast.accept(())
                } else {
                    owner.presentFeedEditNovelConnectModalViewController.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.feedNovelConnectedNotification
            .subscribe(with: self, onNext: { owner, notification in
                guard let connectedNovel = notification.object as? SearchNovel else { return }
                owner.newNovelId = connectedNovel.novelId
                owner.isNovelIdChanged = owner.initialNovelId != owner.newNovelId
                owner.connectedNovelTitle.accept(connectedNovel.novelTitle)
                owner.checkIfCompleteButtonIsAbled()
            })
            .disposed(by: disposeBag)
        
        input.novelRemoveButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.newNovelId = nil
                owner.isNovelIdChanged = owner.initialNovelId != owner.newNovelId
                owner.connectedNovelTitle.accept(nil)
                owner.checkIfCompleteButtonIsAbled()
            })
            .disposed(by: disposeBag)
        
        input.stopEditButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.photoAddButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentPhotoPicker.accept(())
            })
            .disposed(by: disposeBag)
        
        self.selectedImages
            .skip(1)
            .subscribe(with: self, onNext: { owner, images in
                guard let initialImages = owner.initialAddImages else { return }
                owner.isAddImagesChanged = initialImages != images
                owner.checkIfCompleteButtonIsAbled()
            })
            .disposed(by: disposeBag)
        
        let showAddImageView = self.selectedImages
            .map { !$0.isEmpty }
            .distinctUntilChanged()
        
        return Output(endEditing: endEditing.asObservable(),
                      popViewController: popViewController.asObservable(),
                      initialFeedContent: initialFeedContent.asObservable(),
                      isSpoiler: isSpoiler.asObservable(),
                      isPublic: isPublic.asObservable(),
                      feedContentWithLengthLimit: feedContentWithLengthLimit.asObservable(),
                      completeButtonIsAbled: completeButtonIsAbled.asObservable(),
                      showPlaceholder: showPlaceholder.asObservable(),
                      presentFeedEditNovelConnectModalViewController: presentFeedEditNovelConnectModalViewController.asObservable(),
                      connectedNovelTitle: connectedNovelTitle.asObservable(),
                      showAlreadyConnectedToast: showAlreadyConnectedToast.asObservable(),
                      showStopEditingAlert: showStopEditingAlert.asObservable(),
                      presentPhotoPicker: presentPhotoPicker.asObservable(),
                      showAddImageView: showAddImageView,
                      selectedImages: selectedImages.asObservable(),
                      showLoadingView: showLoadingView.asObservable(),
                      backButtonIsAbled: backButtonIsAbled.asObservable())
    }
    
    // MARK: - Custom Method
    
    func isInitialFeedChanged() -> Bool {
        return feedId != nil ? isFeedContentChanged || isSpoilerChanged || isPublicChanged || isNovelIdChanged || isAddImagesChanged : true
    }
    
    func checkIfCompleteButtonIsAbled() {
        self.completeButtonIsAbled.accept(
            self.isValidFeedContent && self.isInitialFeedChanged()
        )
    }
    
    //MARK: - API
    
    private func getSingleFeed(_ feedId: Int) -> Observable<FeedEntity> {
        return feedDetailRepository.getSingleFeedData(feedId: feedId)
            .observe(on: MainScheduler.instance)
    }
    
    private func postFeed(feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void> {
        feedRepository.postFeed(
            feedContent: feedContent,
            novelId: novelId,
            isSpoiler: isSpoiler,
            isPublic: isPublic,
            images: images
        )
        .observe(on: MainScheduler.instance)
    }
    
    private func putFeed(feedId: Int, feedContent: String, novelId: Int?, isSpoiler: Bool, isPublic: Bool, images: [UIImage]) -> Observable<Void> {
        feedRepository.putFeed(
            feedId: feedId,
            feedContent: feedContent,
            novelId: novelId,
            isSpoiler: isSpoiler,
            isPublic: isPublic,
            images: images
        )
        .observe(on: MainScheduler.instance)
    }
}
