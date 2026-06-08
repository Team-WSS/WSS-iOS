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
    private let keywordRepository: KeywordRepository
    private let disposeBag = DisposeBag()

    private let isLogined = APIConstants.isLogined

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

    // 로딩
    private let showLoadingView = PublishRelay<Bool>()

    // 소소픽
    private let sosoPickList = BehaviorRelay<[SosoPickNovel]>(value: [])
    private let presentToInduceLoginView = PublishRelay<Void>()

    // 최근 검색어
    private let recentSearchList = BehaviorRelay<[RecentSearch]>(value: [])

    // 인기 키워드
    private let popularKeywordList = BehaviorRelay<[KeywordData]>(value: [])
    
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
        let sosoPickCellSelected: ControlEvent<IndexPath>
        let viewWillAppear: Observable<Void>
        let recentSearchTagSelected: ControlEvent<IndexPath>
        let recentSearchDeleteAllButtonDidTap: ControlEvent<Void>
        let recentSearchDeleteButtonDidTap: Observable<Int>
        let genreSelected: ControlEvent<IndexPath>
        let genreHeaderDidTap: ControlEvent<Void>
        let popularKeywordSelected: ControlEvent<IndexPath>
        let popularKeywordHeaderDidTap: ControlEvent<Void>
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
        let sosoPickList: Observable<[SosoPickNovel]>
        let presentToInduceLoginView: Observable<Void>
        let recentSearchList: Observable<[RecentSearch]>
        let showRecentSearchView: Driver<Bool>
        let fillSearchTextField: Observable<String>
        let pushToGenreSearchResult: Observable<NovelGenre>
        let pushToDetailSearch: Observable<Void>
        let showGenreView: Driver<Bool>
        let popularKeywordList: Observable<[KeywordData]>
        let pushToKeywordSearchResult: Observable<KeywordData>
        let pushToDetailSearchKeywordTab: Observable<Void>
        let showPopularKeywordView: Driver<Bool>
    }
    
    //MARK: - init
    
    let initialSearchText: String?
    
    init(searchRepository: SearchRepository,
         keywordRepository: KeywordRepository,
         initialSearchText: String? = nil) {
        self.searchRepository = searchRepository
        self.keywordRepository = keywordRepository
        self.initialSearchText = initialSearchText
    }
    
    //MARK: - API
    
    private func getSosoPickNovels() -> Observable<SosoPickNovels> {
        return searchRepository.getSosoPickNovels()
    }

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
                    if page == 0 {
                        self.showLoadingView.accept(true)
                    }
                }
            )
    }
    
    //MARK: - Methods
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        getSosoPickNovels()
            .subscribe(with: self, onNext: { owner, data in
                owner.sosoPickList.accept(data.sosoPicks)
            }, onError: { _, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)

        input.sosoPickCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                AmplitudeManager.shared.track(AmplitudeEvent.Search.sosoPick)
                if owner.isLogined {
                    let novelId = owner.sosoPickList.value[indexPath.row].novelId
                    owner.pushToNovelDetailViewController.accept(novelId)
                } else {
                    owner.presentToInduceLoginView.accept(())
                }
            })
            .disposed(by: disposeBag)

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
                AmplitudeManager.shared.track(AmplitudeEvent.Search.clickSearchResult)
                if owner.isLogined {
                    let novelId = owner.normalSearchList.value[indexPath.row].novelId
                    owner.pushToNovelDetailViewController.accept(novelId)
                } else {
                    owner.presentToInduceLoginView.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        let returnKeyEnabled = input.returnKeyDidTap.asObservable()
        let searchButtonEnabled = input.searchButtonDidTap.asObservable()
        let clearButtonEnabled = input.clearButtonDidTap.asObservable()
        let popViewController = input.backButtonDidTap.asObservable()
        let inquiryButtonEnabled = input.inquiryButtonDidTap
            .asObservable()
            .do(onNext: {
                AmplitudeManager.shared.track(AmplitudeEvent.Search.contactNovelSearch)
            })
        
        let normalSearchCollectionViewHeight = input.normalSearchCollectionViewContentSize
            .map { $0?.height ?? 0 }.asDriver(onErrorJustReturn: 0)
        
        let endEditing = input.normalSearchCollectionViewSwipeGesture
            .map { _ in () }
        
        // 최근 검색어 로직
        input.viewWillAppear
            .filter { self.isLogined }
            .flatMapLatest { _ in
                self.searchRepository.getRecentSearches()
                    .catchAndReturn([])
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.recentSearchList.accept(data)
            })
            .disposed(by: disposeBag)

        input.recentSearchDeleteButtonDidTap
            .do(onNext: { id in
                var list = self.recentSearchList.value
                list.removeAll { $0.id == id }
                self.recentSearchList.accept(list)
            })
            .flatMapLatest { id in
                self.searchRepository.deleteRecentSearch(id: id)
                    .catchAndReturn(())
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.recentSearchDeleteAllButtonDidTap
            .do(onNext: { self.recentSearchList.accept([]) })
            .flatMapLatest { self.searchRepository.deleteAllRecentSearches().catchAndReturn(()) }
            .subscribe()
            .disposed(by: disposeBag)

        let fillSearchTextField = input.recentSearchTagSelected
            .withLatestFrom(recentSearchList) { indexPath, list in list[indexPath.row].keyword }

        let showRecentSearchView = Observable.combineLatest(
            searchText.asObservable(),
            recentSearchList.map { !$0.isEmpty },
            normalSearchList.map { $0.isEmpty }
        )
        .map { text, hasRecent, novelsEmpty in text.isEmpty && hasRecent && novelsEmpty }
        .asDriver(onErrorJustReturn: false)

        let pushToGenreSearchResult = input.genreSelected
            .map { NovelGenre.normalSearchGenres[$0.row] }

        let pushToDetailSearch = input.genreHeaderDidTap.asObservable()

        let showGenreView = Observable.combineLatest(
            searchText.asObservable(),
            normalSearchList.map { $0.isEmpty }
        )
        .map { text, novelsEmpty in text.isEmpty && novelsEmpty }
        .asDriver(onErrorJustReturn: true)

        // 인기 키워드 로직
        input.viewWillAppear
            .filter { self.isLogined }
            .flatMapLatest { _ in
                self.keywordRepository.getPopularKeywords()
                    .catchAndReturn([])
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.popularKeywordList.accept(data)
            })
            .disposed(by: disposeBag)

        let pushToKeywordSearchResult = input.popularKeywordSelected
            .withLatestFrom(popularKeywordList) { indexPath, list in list[indexPath.row] }

        let pushToDetailSearchKeywordTab = input.popularKeywordHeaderDidTap.asObservable()

        let showPopularKeywordView = Observable.combineLatest(
            searchText.asObservable(),
            normalSearchList.map { $0.isEmpty }
        )
        .map { text, novelsEmpty in text.isEmpty && novelsEmpty }
        .asDriver(onErrorJustReturn: true)

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
                      showLoadingView: showLoadingView.asObservable(),
                      sosoPickList: sosoPickList.asObservable(),
                      presentToInduceLoginView: presentToInduceLoginView.asObservable(),
                      recentSearchList: recentSearchList.asObservable(),
                      showRecentSearchView: showRecentSearchView,
                      fillSearchTextField: fillSearchTextField.asObservable(),
                      pushToGenreSearchResult: pushToGenreSearchResult.asObservable(),
                      pushToDetailSearch: pushToDetailSearch,
                      showGenreView: showGenreView,
                      popularKeywordList: popularKeywordList.asObservable(),
                      pushToKeywordSearchResult: pushToKeywordSearchResult.asObservable(),
                      pushToDetailSearchKeywordTab: pushToDetailSearchKeywordTab,
                      showPopularKeywordView: showPopularKeywordView)
    }
}
