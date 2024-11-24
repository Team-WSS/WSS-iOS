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
    
    // API 쿼리
    private let searchText = BehaviorRelay<String>(value: "")
    private var currentPage: Int = 0
    private var isLoadable: Bool = false
    private var isFetching: Bool = false
    
    // Output
    private let resultCount = PublishSubject<Int>()
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let isSearchTextFieldEditing = BehaviorRelay<Bool>(value: false)
    private let normalSearchList = BehaviorRelay<[SearchNovel]>(value: [])
    private let normalSearchCellIndexPath = PublishRelay<IndexPath>()
    private let showLoadingView = PublishRelay<Bool>()
    
    //MARK: - Inputs
    
    struct Input {
        let searchTextUpdated: ControlProperty<String>
        let searchTextFieldEditingDidBegin: ControlEvent<Void>
        let searchTextFieldEditingDidEnd: ControlEvent<Void>
        let returnKeyDidTap: ControlEvent<Void>
        let searchButtonDidTap: ControlEvent<Void>
        let clearButtonDidTap: ControlEvent<Void>
        let backButtonDidTap: ControlEvent<Void>
        let inquiryButtonDidTap: ControlEvent<Void>
        let normalSearchCollectionViewContentSize: Observable<CGSize?>
        let normalSearchCellSelected: ControlEvent<IndexPath>
        let reachedBottom: Observable<Bool>
        let normalSearchCollectionViewSwipeGesture: Observable<UISwipeGestureRecognizer>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let resultCount: Observable<Int>
        let normalSearchList: Observable<[SearchNovel]>
        let scrollToTop: Observable<Void>
        let scrollToTopAndendEditing: Observable<Void>
        let clearButtonEnabled: Observable<Void>
        let popViewController: Observable<Void>
        let inquiryButtonEnabled: Observable<Void>
        let normalSearchCollectionViewHeight: Driver<CGFloat>
        let pushToNovelDetailViewController: Observable<Int>
        let isSearchTextFieldEditing: Observable<Bool>
        let endEditing: Observable<Void>
        let showLoadingView: Observable<Bool>
    }
    
    //MARK: - init
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    //MARK: - API
    
    private func getNormalSearchList(query: String, page: Int) -> Observable<NormalSearchNovels> {
        return searchRepository.getSearchNovels(query: query, page: page)
            .do(
                onNext: { data in
                    if page == 0 {
                        self.normalSearchList.accept(data.novels)
                    } else {
                        let updatedList = self.normalSearchList.value + data.novels
                        self.normalSearchList.accept(updatedList)
                    }
                    self.resultCount.onNext(data.resultCount)
                    self.isLoadable = data.isLoadable
                    self.currentPage = page
                },
                onError: { error in
                    print(error.localizedDescription)
                    self.showLoadingView.accept(false)
                },
                onCompleted: {
                    self.showLoadingView.accept(false)
                },
                onSubscribe: {
                    self.showLoadingView.accept(true)
                }
            )
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
                self.currentPage = 0
            })
            .flatMapLatest { text in
                self.getNormalSearchList(query: text, page: 0)
            }
            .share()
        
        searchRequest
            .subscribe()
            .disposed(by: disposeBag)
        
        input.searchTextFieldEditingDidBegin
            .subscribe(with: self, onNext: { owner, _ in
                owner.isSearchTextFieldEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.searchTextFieldEditingDidEnd
            .subscribe(with: self, onNext: { owner, _ in
                owner.isSearchTextFieldEditing.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.reachedBottom
            .filter { reachedBottom in
                return reachedBottom && !self.isFetching && self.isLoadable
            }
            .do(onNext: { _ in
                self.isFetching = true
            })
            .flatMapLatest { _ in
                self.getNormalSearchList(
                    query: self.searchText.value,
                    page: self.currentPage + 1)
                .do(onNext: { _ in
                    self.isFetching = false
                }, onError: { _ in
                    self.isFetching = false
                })
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        input.normalSearchCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                let novelId = owner.normalSearchList.value[indexPath.row].novelId
                owner.pushToNovelDetailViewController.accept(novelId)
            })
            .disposed(by: disposeBag)
        
        let returnKeyEnabled = input.returnKeyDidTap.asObservable()
        let searchButtonEnabled = input.searchButtonDidTap.asObservable()
        let clearButtonEnabled = input.clearButtonDidTap.asObservable()
        let popViewController = input.backButtonDidTap.asObservable()
        let inquiryButtonEnabled = input.inquiryButtonDidTap.asObservable()
        
        let normalSearchCollectionViewHeight = input.normalSearchCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        let endEditing = input.normalSearchCollectionViewSwipeGesture
            .map { _ in () }
        
        return Output(resultCount: resultCount.asObservable(),
                      normalSearchList: normalSearchList.asObservable(),
                      scrollToTop: returnKeyEnabled.asObservable(),
                      scrollToTopAndendEditing: searchButtonEnabled.asObservable(),
                      clearButtonEnabled: clearButtonEnabled.asObservable(),
                      popViewController: popViewController.asObservable(),
                      inquiryButtonEnabled: inquiryButtonEnabled.asObservable(),
                      normalSearchCollectionViewHeight: normalSearchCollectionViewHeight,
                      pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
                      isSearchTextFieldEditing: isSearchTextFieldEditing.asObservable(),
                      endEditing: endEditing,
                      showLoadingView: showLoadingView.asObservable())
    }
}
