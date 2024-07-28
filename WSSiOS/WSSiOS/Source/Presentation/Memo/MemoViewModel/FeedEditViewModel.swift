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
    private var novelId: Int?
    private var relevantCategories: [String] = []
    private var hasSpoiler: Bool = false
    let initialFeedContent: String = ""
    private var updatedFeedContent: String = "asdfasdf"
    private let feedContentPredicate = NSPredicate(format: "SELF MATCHES %@", "^[\\s]+$")
    private let maximumFeedContentCount: Int = 2000
    
    let dummyCategoryList = ["로맨스",
                             "로판",
                             "BL",
                             "판타지",
                             "현판",
                             "무협",
                             "드라마",
                             "미스터리",
                             "라노벨",
                             "기타"]
       
    //MARK: - Life Cycle
    
    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
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
        let hasSpoiler = BehaviorRelay<Bool>(value: false)
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
                output.categoryListData.accept(owner.dummyCategoryList)
            })
            .disposed(by: disposeBag)
        
        input.backButtonDidTap
            .subscribe(onNext: { _ in
                output.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.completeButtonDidTap
            .flatMapLatest {
                self.postFeed(relevantCategories: self.relevantCategories, feedContent: self.updatedFeedContent, novelId: self.novelId, isSpoiler: self.hasSpoiler)
            }
            .subscribe(onNext: { data in
                print(data)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.spoilerButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                output.hasSpoiler.accept(!owner.hasSpoiler)
                owner.hasSpoiler = !owner.hasSpoiler
            })
            .disposed(by: disposeBag)
        
        input.categoryCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                let selectedCategory = owner.dummyCategoryList[indexPath.item]
                owner.relevantCategories.append(selectedCategory)
                if owner.isValidFeedContent && !owner.relevantCategories.isEmpty {
                    output.completeButtonIsAbled.accept(true)
                } else {
                    output.completeButtonIsAbled.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.categoryCollectionViewItemDeselected
            .subscribe(with: self, onNext: { owner, indexPath in
                let deselectedCategory = owner.dummyCategoryList[indexPath.item]
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
                    owner.isValidFeedContent = false
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
}
