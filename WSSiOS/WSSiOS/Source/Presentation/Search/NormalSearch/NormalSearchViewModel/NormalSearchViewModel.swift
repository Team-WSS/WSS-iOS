//
//  NormalSearchViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NormalSearchViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let searchRepository: SearchRepository
    private let disposeBag = DisposeBag()
    
    private let searchText = BehaviorRelay<String>(value: "")
    private let currentPage = BehaviorRelay<Int>(value: 0)
    private let isLoadable = BehaviorRelay<Bool>(value: false)
    private let resultCount = PublishSubject<Int>()
    private let normalSearchList = BehaviorRelay<[NormalSearchNovel]>(value: [])
    private let normalSearchCellIndexPath = PublishRelay<IndexPath>()
    
    //MARK: - Inputs
    
    struct Input {
        let searchTextUpdated: ControlProperty<String>
        let returnKeyDidTap: ControlEvent<Void>
        let searchButtonDidTap: ControlEvent<Void>
        let clearButtonDidTap: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
        let inquiryButtonDidTap: ControlEvent<Void>
        let normalSearchCollectionViewContentSize: Observable<CGSize?>
        let normalSearchCellSelected: ControlEvent<IndexPath>
        let reachedBottom: Observable<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let resultCount: Observable<Int>
        let normalSearchList: Observable<[NormalSearchNovel]>
        let returnKeyEnabled: Observable<Void>
        let searchButtonEnabled: Observable<Void>
        let clearButtonEnabled: Observable<Void>
        let backButtonEnabled: Observable<Void>
        let inquiryButtonEnabled: Observable<Void>
        let normalSearchCollectionViewHeight: Driver<CGFloat>
        let normalSearchCellEnabled: Observable<IndexPath>
    }
    
    //MARK: - init
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    //MARK: - Methods
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        let searchRequest = Observable.merge(input.returnKeyDidTap.asObservable(), 
                                             input.searchButtonDidTap.asObservable())
            .withLatestFrom(input.searchTextUpdated)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .do(onNext: { text in
                self.searchText.accept(text)
                self.currentPage.accept(0)
            })
            .flatMapLatest { text in
                self.searchRepository.getSearchNovels(query: text, page: 0)
            }
            .share()
        
        searchRequest
            .subscribe(with: self, onNext: { owner, data in
                owner.normalSearchList.accept(data.novels)
                owner.resultCount.onNext(data.resultCount)
                owner.isLoadable.accept(data.isLoadable)
            })
            .disposed(by: disposeBag)
        
        input.reachedBottom
            .withLatestFrom(isLoadable)
            .filter { $0 }
            .withLatestFrom(currentPage)
            .flatMapLatest { page -> Observable<NormalSearchNovels> in
                let nextPage = page + 1
                return self.searchRepository.getSearchNovels(query: self.searchText.value, page: nextPage)
                    .do(onNext: { _ in
                        self.currentPage.accept(nextPage)
                    })
            }
            .subscribe(with: self, onNext: { owner, data in
                let updatedList = owner.normalSearchList.value + data.novels
                owner.normalSearchList.accept(updatedList)
                owner.isLoadable.accept(data.isLoadable)
            })
            .disposed(by: disposeBag)
        
        input.normalSearchCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.normalSearchCellIndexPath.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        let returnKeyEnabled = input.returnKeyDidTap.asObservable()
        let searchButtonEnabled = input.searchButtonDidTap.asObservable()
        let clearButtonEnabled = input.clearButtonDidTap.asObservable()
        let backButtonEnabled = input.backButtonDidTap.asObservable()
        let inquiryButtonEnabled = input.inquiryButtonDidTap.asObservable()
        
        let normalSearchCollectionViewHeight = input.normalSearchCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        return Output(resultCount: resultCount.asObservable(),
                      normalSearchList: normalSearchList.asObservable(),
                      returnKeyEnabled: returnKeyEnabled.asObservable(),
                      searchButtonEnabled: searchButtonEnabled.asObservable(),
                      clearButtonEnabled: clearButtonEnabled.asObservable(),
                      backButtonEnabled: backButtonEnabled.asObservable(),
                      inquiryButtonEnabled: inquiryButtonEnabled.asObservable(),
                      normalSearchCollectionViewHeight: normalSearchCollectionViewHeight,
                      normalSearchCellEnabled: normalSearchCellIndexPath.asObservable())
    }
}
