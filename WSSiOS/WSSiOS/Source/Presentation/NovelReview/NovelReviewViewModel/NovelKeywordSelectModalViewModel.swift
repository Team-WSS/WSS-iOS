//
//  NovelKeywordSelectModalViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/17/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelKeywordSelectModalViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let keywordRepository: KeywordRepository
    var keywordSearchResultList: [KeywordData] = []
    var selectedKeywordList: [KeywordData]
    
    private let keywordLimit: Int = 20
    
    // Output
    
    private let dismissModalViewController = PublishRelay<Void>()
    private let enteredText = BehaviorRelay<String>(value: "")
    private let isKeywordTextFieldEditing = BehaviorRelay<Bool>(value: false)
    private let endEditing = PublishRelay<Void>()
    private let selectedKeywordListData = BehaviorRelay<[KeywordData]>(value: [])
    private let keywordSearchResultListData = PublishRelay<[KeywordData]>()
    private let isKeywordCountOverLimit = PublishRelay<IndexPath>()
    private let showEmptyView = PublishRelay<Bool>()
    
    //MARK: - Life Cycle
    
    init(keywordRepository: KeywordRepository, selectedKeywordList: [KeywordData]) {
        self.keywordRepository = keywordRepository
        self.selectedKeywordList = selectedKeywordList
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let updatedEnteredText: Observable<String>
        let keywordTextFieldEditingDidBegin: ControlEvent<Void>
        let keywordTextFieldEditingDidEnd: ControlEvent<Void>
        let keywordTextFieldEditingDidEndOnExit: ControlEvent<Void>
        let searchCancelButtonDidTap: ControlEvent<Void>
        let closeButtonDidTap: ControlEvent<Void>
        let searchButtonDidTap: ControlEvent<Void>
        let selectedKeywordCollectionViewItemSelected: Observable<IndexPath>
        let searchResultCollectionViewItemSelected: Observable<IndexPath>
        let searchResultCollectionViewItemDeselected: Observable<IndexPath>
        let resetButtonDidTap: ControlEvent<Void>
        let selectButtonDidTap: ControlEvent<Void>
        let contactButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let dismissModalViewController: Observable<Void>
        let enteredText: Observable<String>
        let isKeywordTextFieldEditing: Observable<Bool>
        let endEditing: Observable<Void>
        let selectedKeywordListData: Observable<[KeywordData]>
        let keywordSearchResultListData: Observable<[KeywordData]>
        let isKeywordCountOverLimit: Observable<IndexPath>
        let showEmptyView: Observable<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .subscribe(with: self, onNext: { owner, _ in
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
            })
            .disposed(by: disposeBag)
        
        input.updatedEnteredText
            .subscribe(with: self, onNext: { owner, text in
                owner.enteredText.accept(text)
             })
            .disposed(by: disposeBag)
        
        input.keywordTextFieldEditingDidBegin
            .subscribe(with: self, onNext: { owner, _ in
                owner.isKeywordTextFieldEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.keywordTextFieldEditingDidEnd
            .subscribe(with: self, onNext: { owner, _ in
                owner.isKeywordTextFieldEditing.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.searchCancelButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.enteredText.accept("")
                owner.showEmptyView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.closeButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.keywordTextFieldEditingDidEndOnExit.asObservable(),
            input.searchButtonDidTap.asObservable()
        )
        .do(onNext: {
            self.endEditing.accept(())
        })
        .withLatestFrom(enteredText)
        .flatMapLatest { enteredText in
            self.searchKeyword(query: enteredText)
        }
        .subscribe(with: self, onNext: { owner, data in
            owner.keywordSearchResultList = data.categories.flatMap { $0.keywords }
            owner.keywordSearchResultListData.accept(owner.keywordSearchResultList)
        }, onError: { owner, error in
            print(error)
        })
        .disposed(by: disposeBag)
        
        input.selectedKeywordCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.endEditing.accept(())
                owner.selectedKeywordList.remove(at: indexPath.item)
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
                owner.keywordSearchResultListData.accept(owner.keywordSearchResultList)
            })
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                if owner.selectedKeywordList.count >= owner.keywordLimit {
                    owner.isKeywordCountOverLimit.accept(indexPath)
                } else {
                    owner.selectedKeywordList.append(owner.keywordSearchResultList[indexPath.item])
                }
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
                owner.endEditing.accept(())
            })
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewItemDeselected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.selectedKeywordList.removeAll { $0.keywordName == owner.keywordSearchResultList[indexPath.item].keywordName }
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
                owner.endEditing.accept(())
            })
            .disposed(by: disposeBag)
        
        input.resetButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.selectedKeywordList = []
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
                owner.enteredText.accept("")
                owner.keywordSearchResultListData.accept([])
                owner.showEmptyView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.selectButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: NSNotification.Name("NovelReviewKeywordSelected"), object: owner.selectedKeywordList)
                owner.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.contactButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                //키워드 문의 뷰로 이동
                print("contactButtonDidTap")
            })
            .disposed(by: disposeBag)
        
        return Output(dismissModalViewController: dismissModalViewController.asObservable(),
                      enteredText: enteredText.asObservable(),
                      isKeywordTextFieldEditing: isKeywordTextFieldEditing.asObservable(),
                      endEditing: endEditing.asObservable(),
                      selectedKeywordListData: selectedKeywordListData.asObservable(),
                      keywordSearchResultListData: keywordSearchResultListData.asObservable(),
                      isKeywordCountOverLimit: isKeywordCountOverLimit.asObservable(),
                      showEmptyView: showEmptyView.asObservable())
    }
    
    //MARK: - API
    
    private func searchKeyword(query: String? = nil) -> Observable<SearchKeywordResult> {
        keywordRepository.searchKeyword(query: query)
            .observe(on: MainScheduler.instance)
    }
}
