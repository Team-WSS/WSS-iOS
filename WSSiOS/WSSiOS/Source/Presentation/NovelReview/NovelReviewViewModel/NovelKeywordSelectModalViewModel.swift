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
    
    var keywordSearchResultList: [String] = ["환생생", "환생남주", "환생이", "환생물", "환생", "환환생", "환생여주", "환환환생", "후회", "정치물", "피폐", "빙의", "먼치킨", "기억상실", "가가", "나나", "다다다", "라라랄", "마마마마마", "밥", "사삿", "아아앙", "자자", "차촟", "카카카", "타톹", "파포", "하히히"]
    var selectedKeywordList: [String]
    
    private let keywordLimit: Int = 20
    
    // Output
    
    private let dismissModalViewController = PublishRelay<Void>()
    private let enteredText = BehaviorRelay<String>(value: "")
    private let selectedKeywordListData = BehaviorRelay<[String]>(value: [])
    private let keywordSearchResultListData = BehaviorRelay<[String]>(value: [])
    private let searchResultCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    private let isKeywordCountOverLimit = PublishRelay<IndexPath>()
    
    //MARK: - Life Cycle
    
    init(selectedKeywordList: [String]) {
        self.selectedKeywordList = selectedKeywordList
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let updatedEnteredText: Observable<String>
        let searchCancelButtonDidTap: ControlEvent<Void>
        let closeButtonDidTap: ControlEvent<Void>
        let searchButtonDidTap: ControlEvent<Void>
        let selectedKeywordCollectionViewItemSelected: Observable<IndexPath>
        let searchResultCollectionViewContentSize: Observable<CGSize?>
        let searchResultCollectionViewItemSelected: Observable<IndexPath>
        let searchResultCollectionViewItemDeselected: Observable<IndexPath>
        let resetButtonDidTap: ControlEvent<Void>
        let selectButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let dismissModalViewController: Observable<Void>
        let enteredText: Observable<String>
        let selectedKeywordListData: Observable<[String]>
        let keywordSearchResultListData: Observable<[String]>
        let searchResultCollectionViewHeight: Observable<CGFloat>
        let isKeywordCountOverLimit: Observable<IndexPath>
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
        
        input.searchCancelButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.enteredText.accept("")
            })
            .disposed(by: disposeBag)
        
        input.closeButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.searchButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.keywordSearchResultListData.accept(owner.keywordSearchResultList)
            })
            .disposed(by: disposeBag)
        
        input.selectedKeywordCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.selectedKeywordList.remove(at: indexPath.item)
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
                owner.keywordSearchResultListData.accept(owner.keywordSearchResultList)
            })
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: self.searchResultCollectionViewHeight)
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                if owner.selectedKeywordList.count >= owner.keywordLimit {
                    owner.isKeywordCountOverLimit.accept(indexPath)
                } else {
                    owner.selectedKeywordList.append(owner.keywordSearchResultList[indexPath.item])
                }
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
            })
            .disposed(by: disposeBag)
        
        input.searchResultCollectionViewItemDeselected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.selectedKeywordList.removeAll { $0 == owner.keywordSearchResultList[indexPath.item] }
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
            })
            .disposed(by: disposeBag)
        
        input.resetButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.selectedKeywordList = []
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
                owner.keywordSearchResultListData.accept(owner.keywordSearchResultList)
            })
            .disposed(by: disposeBag)
        
        input.selectButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: NSNotification.Name("NovelReviewKeywordSelected"), object: owner.selectedKeywordList)
                owner.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(dismissModalViewController: dismissModalViewController.asObservable(),
                      enteredText: enteredText.asObservable(),
                      selectedKeywordListData: selectedKeywordListData.asObservable(),
                      keywordSearchResultListData: keywordSearchResultListData.asObservable(),
                      searchResultCollectionViewHeight: searchResultCollectionViewHeight.asObservable(),
                      isKeywordCountOverLimit: isKeywordCountOverLimit.asObservable())
    }
}
