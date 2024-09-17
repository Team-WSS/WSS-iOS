//
//  FeedEditViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import RxSwift
import RxCocoa

enum FeedDetailWomanKoreanGenreDummy: String, CaseIterable {
    case 판타지 = "판타지"
    case 현판 = "현판"
    case 로맨스 = "로맨스"
    case 로판 = "로판"
    case 무협 = "무협"
    case 드라마 = "드라마"
    case 미스터리 = "미스터리"
    case 라노벨 = "라노벨"
    case BL = "BL"
    case 기타 = "기타"
    
    var toEnglish: String {
        switch self {
        case .판타지:
            return "fantasy"
        case .현판:
            return "modernFantasy"
        case .로맨스:
            return "romance"
        case .로판:
            return "romanceFantasy"
        case .무협:
            return "wuxia"
        case .드라마:
            return "drama"
        case .미스터리:
            return "mystery"
        case .라노벨:
            return "lightNovel"
        case .BL:
            return "BL"
        case .기타:
            return "etc"
        }
    }
}

final class FeedEditViewModel: ViewModelType {
    
    //MARK: - Properties
        
    private let memoRepository: MemoRepository
    
    private var isValidFeedContent: Bool = false
    private let feedId: Int?
    let initialFeedContent: String?
    private var novelId: Int?
    var relevantCategories: [String] = []
    var isSpoiler: Bool = false
    private var updatedFeedContent: String = ""
    private let feedContentPredicate = NSPredicate(format: "SELF MATCHES %@", "^[\\s]+$")
    private let maximumFeedContentCount: Int = 2000
    
    //TODO: - 성별에 따른 리스트는 추후 구현
    let relevantCategoryList = FeedDetailWomanKoreanGenreDummy.allCases.map { $0.rawValue }
       
    //MARK: - Life Cycle
    
    init(memoRepository: MemoRepository, feedId: Int? = nil, relevantCategories: [String] = [], initialFeedContent: String? = nil, novelId: Int? = nil, isSpoiler: Bool = false) {
        self.memoRepository = memoRepository
        self.feedId = feedId
        self.relevantCategories = relevantCategories
        self.initialFeedContent = initialFeedContent
        self.novelId = novelId
        self.isSpoiler = isSpoiler
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
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
    }
    
    struct Output {
        let endEditing = PublishRelay<Bool>()
        let categoryListData = PublishRelay<[String]>()
        let popViewController = PublishRelay<Void>()
        let isSpoiler = PublishRelay<Bool>()
        let feedContentWithLengthLimit = BehaviorRelay<String>(value: "")
        let completeButtonIsAbled = BehaviorRelay<Bool>(value: false)
        let showPlaceholder = PublishRelay<Bool>()
        let presentFeedEditNovelConnectModalViewController = PublishRelay<Void>()
        let connectedNovelTitle = PublishRelay<String?>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidTap
            .subscribe(onNext: { _ in
                output.endEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.categoryListData.accept(owner.relevantCategoryList)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                output.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        if let feedId {
            input.completeButtonDidTap
                .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
                .flatMapLatest {
                    self.putFeed(feedId: feedId, relevantCategories: self.relevantCategories, feedContent: self.updatedFeedContent, novelId: self.novelId, isSpoiler: self.isSpoiler)
                }
                .subscribe(onNext: { data in
                    print(data)
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        } else {
            input.completeButtonDidTap
                .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
                .flatMapLatest {
                    self.postFeed(relevantCategories: self.relevantCategories, feedContent: self.updatedFeedContent, novelId: self.novelId, isSpoiler: self.isSpoiler)
                }
                .subscribe(onNext: { data in
                    print(data)
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
        
        input.spoilerButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.isSpoiler.accept(!owner.isSpoiler)
                owner.isSpoiler = !owner.isSpoiler
            })
            .disposed(by: disposeBag)
        
        input.categoryCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                let selectedCategory = owner.relevantCategoryList[indexPath.item]
                if let englishCategory = FeedDetailWomanKoreanGenreDummy(rawValue: selectedCategory)?.toEnglish {
                    owner.relevantCategories.append(englishCategory)
                }
                output.completeButtonIsAbled.accept(owner.isValidFeedContent && !owner.relevantCategories.isEmpty)
            })
            .disposed(by: disposeBag)
        
        input.categoryCollectionViewItemDeselected
            .subscribe(with: self, onNext: { owner, indexPath in
                let deselectedCategory = owner.relevantCategoryList[indexPath.item]
                if let englishCategory = FeedDetailWomanKoreanGenreDummy(rawValue: deselectedCategory)?.toEnglish {
                    owner.relevantCategories.removeAll { $0 == englishCategory }
                }
                output.completeButtonIsAbled.accept(owner.isValidFeedContent && !owner.relevantCategories.isEmpty)
            })
            .disposed(by: disposeBag)
        
        input.feedContentUpdated
            .subscribe(with: self, onNext: { owner, text in
                owner.updatedFeedContent = text
                output.feedContentWithLengthLimit.accept(String(text.prefix(owner.maximumFeedContentCount)))
                
                let isEmpty = text.count == 0
                let isOverLimit = text.count > owner.maximumFeedContentCount
                let isWrongFormat = owner.feedContentPredicate.evaluate(with: text)
                let isNotChanged = text == owner.initialFeedContent
                
                owner.isValidFeedContent = !(isEmpty || isOverLimit || isWrongFormat || isNotChanged)
                
                output.showPlaceholder.accept(isEmpty)
                output.completeButtonIsAbled.accept(owner.isValidFeedContent && !owner.relevantCategories.isEmpty)
            })
            .disposed(by: disposeBag)
        
        input.feedContentViewDidBeginEditing
            .subscribe(onNext: { _ in
                output.showPlaceholder.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.feedContentViewDidEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                output.showPlaceholder.accept(owner.updatedFeedContent.count == 0 ? true : false)
            })
            .disposed(by: disposeBag)
        
        input.novelConnectViewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.presentFeedEditNovelConnectModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.feedNovelConnectedNotification
            .subscribe(with: self, onNext: { owner, notification in
                guard let connectedNovel = notification.object as? NormalSearchNovel else { return }
                owner.novelId = connectedNovel.novelId
                output.connectedNovelTitle.accept(connectedNovel.novelTitle)
            })
            .disposed(by: disposeBag)
        
        input.novelRemoveButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.novelId = nil
                output.connectedNovelTitle.accept(nil)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func postFeed(relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        memoRepository.postFeed(relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)
            .observe(on: MainScheduler.instance)
    }
    
    private func putFeed(feedId: Int, relevantCategories: [String], feedContent: String, novelId: Int?, isSpoiler: Bool) -> Observable<Void> {
        memoRepository.putFeed(feedId: feedId, relevantCategories: relevantCategories, feedContent: feedContent, novelId: novelId, isSpoiler: isSpoiler)
            .observe(on: MainScheduler.instance)
    }
}
