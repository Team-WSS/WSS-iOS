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
    
    let relevantCategoryList: [NewNovelGenre] = NewNovelGenre.feedEditGenres
    
    private var isValidFeedContent: Bool = false
    private let feedContentPredicate = NSPredicate(format: "SELF MATCHES %@", "^[\\s]+$")
    private let maximumFeedContentCount: Int = 2000
    
    private let feedId: Int?
    var newRelevantCategories: [NewNovelGenre] = []
    private var newNovelId: Int?
    private var newFeedContent: String = ""
    
    // 기존 피드 수정
    private var initialRelevantCategories: [NewNovelGenre]?
    private var initialIsSpoiler: Bool?
    private var initialNovelId: Int?
    private var isRelevantCategoriesChanged: Bool = false
    private var isFeedContentChanged: Bool = false
    private var isSpoilerChanged: Bool = false
    private var isNovelIdChanged: Bool = false
    
    // Output
    private let endEditing = PublishRelay<Bool>()
    private let categoryListData = BehaviorRelay<[NewNovelGenre]>(value: NewNovelGenre.feedEditGenres)
    private let popViewController = PublishRelay<Void>()
    private let initialFeedContent = BehaviorRelay<String>(value: "")
    private let isSpoiler = BehaviorRelay<Bool>(value: false)
    private let feedContentWithLengthLimit = BehaviorRelay<String>(value: "")
    private let completeButtonIsAbled = BehaviorRelay<Bool>(value: false)
    private let showPlaceholder = BehaviorRelay<Bool>(value: true)
    private let presentFeedEditNovelConnectModalViewController = PublishRelay<Void>()
    private let connectedNovelTitle = BehaviorRelay<String?>(value: nil)
    private let showAlreadyConnectedToast = PublishRelay<Void>()
    private let showStopEditingAlert = PublishRelay<Void>()
    
    //MARK: - Life Cycle
    
    init(feedRepository: FeedRepository, feedDetailRepository: FeedDetailRepository, feedId: Int? = nil, relevantCategories: [NewNovelGenre] = [], novelId: Int? = nil, novelTitle: String? = nil) {
        self.feedRepository = feedRepository
        self.feedDetailRepository = feedDetailRepository
        
        self.feedId = feedId
        self.newRelevantCategories = relevantCategories
        self.newNovelId = novelId
        
        self.connectedNovelTitle.accept(novelTitle)
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewDidTap: Observable<UITapGestureRecognizer>
        let backButtonDidTap: ControlEvent<Void>
        let completeButtonDidTap: ControlEvent<Void>
        let spoilerButtonDidTap: ControlEvent<Void>
        let categoryCollectionViewItemSelected: Observable<IndexPath>
        let categoryCollectionViewItemDeselected: Observable<IndexPath>
        let feedContentUpdated: Observable<String>
        let feedContentViewDidBeginEditing: ControlEvent<Void>
        let feedContentViewDidEndEditing: ControlEvent<Void>
        let novelConnectViewDidTap: Observable<UITapGestureRecognizer>
        let feedNovelConnectedNotification: Observable<Notification>
        let novelRemoveButtonDidTap: ControlEvent<Void>
        let stopEditButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let endEditing: Observable<Bool>
        let categoryListData: Observable<[NewNovelGenre]>
        let popViewController: Observable<Void>
        let initialFeedContent: Observable<String>
        let isSpoiler: Observable<Bool>
        let feedContentWithLengthLimit: Observable<String>
        let completeButtonIsAbled: Observable<Bool>
        let showPlaceholder: Observable<Bool>
        let presentFeedEditNovelConnectModalViewController: Observable<Void>
        let connectedNovelTitle: Observable<String?>
        let showAlreadyConnectedToast: Observable<Void>
        let showStopEditingAlert: Observable<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .compactMap { [weak self] in self?.feedId }
            .flatMapLatest { feedId in
                self.getSingleFeed(feedId)
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.initialRelevantCategories = data.genres.map { NewNovelGenre.withKoreanRawValue(from: $0) }
                owner.newRelevantCategories = data.genres.map { NewNovelGenre.withKoreanRawValue(from: $0) }
                owner.categoryListData.accept(self.relevantCategoryList)
                
                owner.initialFeedContent.accept(data.feedContent)
                
                owner.initialNovelId = data.novelId
                owner.newNovelId = data.novelId
                owner.connectedNovelTitle.accept(data.novelTitle)
                
                owner.initialIsSpoiler = data.isSpoiler
                owner.isSpoiler.accept(data.isSpoiler)
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
            .withLatestFrom(isSpoiler)
            .flatMapLatest { isSpoiler in
                
                if let feedId = self.feedId {
                    self.putFeed(feedId: feedId, relevantCategories: self.newRelevantCategories.map { $0.rawValue }, feedContent: self.newFeedContent, novelId: self.newNovelId, isSpoiler: isSpoiler)
                } else {
                    self.postFeed(relevantCategories: self.newRelevantCategories.map { $0.rawValue }, feedContent: self.newFeedContent, novelId: self.newNovelId, isSpoiler: isSpoiler)
                }
            }
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: NSNotification.Name("FeedEdited"), object: nil)
                owner.popViewController.accept(())
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
        
        input.categoryCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.newRelevantCategories.append(owner.relevantCategoryList[indexPath.item])
                owner.isRelevantCategoriesChanged = Set(self.initialRelevantCategories ?? []) != Set(self.newRelevantCategories)
                owner.checkIfCompleteButtonIsAbled()
            })
            .disposed(by: disposeBag)
        
        input.categoryCollectionViewItemDeselected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.newRelevantCategories.removeAll { $0 == owner.relevantCategoryList[indexPath.item]}
                owner.isRelevantCategoriesChanged = Set(self.initialRelevantCategories ?? []) != Set(self.newRelevantCategories)
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
        
        return Output(endEditing: endEditing.asObservable(),
                      categoryListData: categoryListData.asObservable(),
                      popViewController: popViewController.asObservable(),
                      initialFeedContent: initialFeedContent.asObservable(),
                      isSpoiler: isSpoiler.asObservable(),
                      feedContentWithLengthLimit: feedContentWithLengthLimit.asObservable(),
                      completeButtonIsAbled: completeButtonIsAbled.asObservable(),
                      showPlaceholder: showPlaceholder.asObservable(),
                      presentFeedEditNovelConnectModalViewController: presentFeedEditNovelConnectModalViewController.asObservable(),
                      connectedNovelTitle: connectedNovelTitle.asObservable(),
                      showAlreadyConnectedToast: showAlreadyConnectedToast.asObservable(),
                      showStopEditingAlert: showStopEditingAlert.asObservable())
    }
    
    // MARK: - Custom Method
    
    func isInitialFeedChanged() -> Bool {
        return feedId != nil ? isRelevantCategoriesChanged || isFeedContentChanged || isSpoilerChanged || isNovelIdChanged : true
    }
    
    func checkIfCompleteButtonIsAbled() {
        self.completeButtonIsAbled.accept(self.isValidFeedContent && !self.newRelevantCategories.isEmpty && self.isInitialFeedChanged())
    }
    
    //MARK: - API
    
    private func getSingleFeed(_ feedId: Int) -> Observable<Feed> {
        return feedDetailRepository.getSingleFeedData(feedId: feedId)
            .observe(on: MainScheduler.instance)
    }
    
    private func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        feedRepository.postFeed(relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)
            .observe(on: MainScheduler.instance)
    }
    
    private func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        feedRepository.putFeed(feedId: feedId, relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)
            .observe(on: MainScheduler.instance)
    }
}
