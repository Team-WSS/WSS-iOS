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
    
    // 성별에 따른 리스트는 추후 구현
    let relevantCategoryList = FeedDetailWomanKoreanGenre.allCases.map { $0.rawValue }
       
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
    }
    
    struct Output {
        let endEditing = PublishRelay<Bool>()
        let categoryListData = PublishRelay<[String]>()
        let popViewController = PublishRelay<Void>()
        let isSpoiler = PublishRelay<Bool>()
        let feedContentWithLengthLimit = BehaviorRelay<String>(value: "")
        let completeButtonIsAbled = BehaviorRelay<Bool>(value: false)
        let showPlaceholder = PublishRelay<Bool>()
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
            .subscribe(onNext: { _ in
                output.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        if let feedId {
            input.completeButtonDidTap
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
                .flatMapLatest {
                    self.postFeed(relevantCategories: self.relevantCategories, feedContent: "asdfasdf", novelId: self.novelId, isSpoiler: self.isSpoiler)
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
                if let englishCategory = FeedDetailWomanKoreanGenre(rawValue: selectedCategory)?.toEnglish {
                    owner.relevantCategories.append(englishCategory)
                }
                print(owner.relevantCategories)
                if owner.isValidFeedContent && !owner.relevantCategories.isEmpty {
                    output.completeButtonIsAbled.accept(true)
                } else {
                    output.completeButtonIsAbled.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.categoryCollectionViewItemDeselected
            .subscribe(with: self, onNext: { owner, indexPath in
                let deselectedCategory = owner.relevantCategoryList[indexPath.item]
                owner.relevantCategories.removeAll { $0 == deselectedCategory }
                if owner.isValidFeedContent && !owner.relevantCategories.isEmpty {
                    output.completeButtonIsAbled.accept(true)
                } else {
                    output.completeButtonIsAbled.accept(false)
                }
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
                
                if isEmpty || isOverLimit || isWrongFormat || isNotChanged {
                    owner.isValidFeedContent = true
                } else {
                    owner.isValidFeedContent = true
                }
                
                if owner.isValidFeedContent && !owner.relevantCategories.isEmpty {
                    output.completeButtonIsAbled.accept(true)
                } else {
                    output.completeButtonIsAbled.accept(false)
                }
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
