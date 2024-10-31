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
    private let isLoggedIn: Bool
    
    private let searchText = BehaviorRelay<String>(value: "")
    private let currentPage = BehaviorRelay<Int>(value: 0)
    private let isLoadable = BehaviorRelay<Bool>(value: false)
    private let resultCount = PublishSubject<Int>()
    private let normalSearchList = BehaviorRelay<[NormalSearchNovel]>(value: [])

    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let isSearchTextFieldEditing = BehaviorRelay<Bool>(value: false)
    
    private let pushToLoginViewController = PublishRelay<Void>()
    private let showInduceLoginModalView = BehaviorRelay<Bool>(value: false)
    
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
        let reachedBottom: Observable<Void>
        let normalSearchCollectionViewSwipeGesture: Observable<UISwipeGestureRecognizer>
        
        // 로그인 유도모달
        let induceModalViewLoginButtonDidtap: ControlEvent<Void>
        let induceModalViewCancelButtonDidtap: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let resultCount: Observable<Int>
        let normalSearchList: Observable<[NormalSearchNovel]>
        let scrollToTop: Observable<Void>
        let scrollToTopAndendEditing: Observable<Void>
        let clearButtonEnabled: Observable<Void>
        let popViewController: Observable<Void>
        let inquiryButtonEnabled: Observable<Void>
        let normalSearchCollectionViewHeight: Driver<CGFloat>
        let pushToNovelDetailViewController: Observable<Int>
        let isSearchTextFieldEditing: Observable<Bool>
        let endEditing: Observable<Void>
        
        // 로그인 유도모달
        let pushToLoginViewController: Observable<Void>
        let showInduceLoginModalView: Observable<Bool>
    }
    
    //MARK: - init
    
    init(searchRepository: SearchRepository, isLoggedIn: Bool) {
        self.searchRepository = searchRepository
        self.isLoggedIn = isLoggedIn
    }
    
    //MARK: - API
    
    private func getNormalSearchList(query: String, page: Int) -> Observable<NormalSearchNovels> {
        return searchRepository.getSearchNovels(query: query, page: page)
            .do(onNext: { data in
                if page == 0 {
                    self.normalSearchList.accept(data.novels)
                } else {
                    let updatedList = self.normalSearchList.value + data.novels
                    self.normalSearchList.accept(updatedList)
                }
                self.resultCount.onNext(data.resultCount)
                self.isLoadable.accept(data.isLoadable)
                self.currentPage.accept(page)
            }, onError: { error in
                print(error.localizedDescription)
            })
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
            .withLatestFrom(isLoadable)
            .filter { $0 }
            .withLatestFrom(currentPage)
            .flatMapLatest { page -> Observable<NormalSearchNovels> in
                let nextPage = page + 1
                return self.getNormalSearchList(query: self.searchText.value, page: nextPage)
                    .do(onNext: { _ in
                        self.currentPage.accept(nextPage)
                    })
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        input.normalSearchCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                if owner.isLoggedIn {
                    let novelId = owner.normalSearchList.value[indexPath.row].novelId
                    owner.pushToNovelDetailViewController.accept(novelId)
                } else {
                    owner.showInduceLoginModalView.accept(true)
                }
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
        
        input.induceModalViewLoginButtonDidtap
            .subscribe(with: self, onNext: { owner, _ in
                owner.pushToLoginViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.induceModalViewCancelButtonDidtap
            .subscribe(with: self, onNext: { owner, _ in
                owner.showInduceLoginModalView.accept(false)
            })
            .disposed(by: disposeBag)
        
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
                      pushToLoginViewController: pushToLoginViewController.asObservable(),
                      showInduceLoginModalView: showInduceLoginModalView.asObservable())
    }
}
