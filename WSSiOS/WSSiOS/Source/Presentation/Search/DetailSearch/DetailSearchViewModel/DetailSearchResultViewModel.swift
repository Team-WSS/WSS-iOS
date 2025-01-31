//
//  DetailSearchResultViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailSearchResultViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let searchRepository: SearchRepository
    
    // API 쿼리
    var keywords: [KeywordData]
    var genres: [NovelGenre]
    var isCompleted: Bool?
    var novelRating: Float?
    
    // 무한 스크롤
    private var currentPage: Int = 0
    private var isLoadable: Bool = false
    private var isFetching: Bool = false
    
    // Output
    private let popViewController = PublishRelay<Void>()
    private let novelCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let presentDetailSearchModal = PublishRelay<SearchFilterQuery>()
    private let showEmptyView = PublishRelay<Bool>()
    
    private let filteredNovelsData = BehaviorRelay<[SearchNovel]>(value: [])
    private let resultCount = BehaviorRelay<Int>(value: 0)
    private let updateDetailSearchResultNotification = PublishRelay<Notification>()
    private let showLoadingView = PublishRelay<Bool>()
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let novelCollectionViewContentSize: Observable<CGSize?>
        let novelResultCellSelected: ControlEvent<IndexPath>
        let searchHeaderViewDidTap: Observable<UITapGestureRecognizer>
        
        let viewDidLoadEvent: Observable<Void>
        let novelCollectionViewReachedBottom: Observable<Bool>
        let updateDetailSearchResultNotification: Observable<Notification>
    }
    
    struct Output {
        let popViewController: Observable<Void>
        let novelCollectionViewHeight: Observable<CGFloat>
        let pushToNovelDetailViewController: Observable<Int>
        let presentDetailSearchModal: Observable<SearchFilterQuery>
        
        let filteredNovelsData: Observable<[SearchNovel]>
        let resultCount: Driver<Int>
        let showEmptyView: Observable<Bool>
        let showLoadingView: Observable<Bool>
    }
    
    init(searchRepository: SearchRepository,
         keywords: [KeywordData],
         genres: [NovelGenre],
         isCompleted: Bool?,
         novelRating: Float?) {
        self.searchRepository = searchRepository
        self.keywords = keywords
        self.genres = genres
        self.isCompleted = isCompleted
        self.novelRating = novelRating
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.backButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.novelCollectionViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: self.novelCollectionViewHeight)
            .disposed(by: disposeBag)
        
        input.novelResultCellSelected
            .do(onNext: { _ in
                AmplitudeManager.shared.track(AmplitudeEvent.Search.clickSeekResult)
            })
            .withLatestFrom(filteredNovelsData) { indexPath, data in
                data[indexPath.row].novelId
            }
            .bind(to: pushToNovelDetailViewController)
            .disposed(by: disposeBag)
        
        input.searchHeaderViewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                let filterQuery = SearchFilterQuery(
                    keywords: owner.keywords,
                    genres: owner.genres,
                    isCompleted: owner.isCompleted,
                    novelRating: owner.novelRating
                )
                owner.presentDetailSearchModal.accept(filterQuery)
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoadEvent
            .do(onNext: {
                self.showLoadingView.accept(true)
            })
            .flatMapLatest {
                return self.getDetailSearchNovels(
                    genres: self.genres.map { $0.rawValue },
                    isCompleted: self.isCompleted,
                    novelRating: self.novelRating,
                    keywordIds: self.keywords.map { $0.keywordId },
                    page: 0
                )
            }
            .subscribe(onNext: { result in
                self.filteredNovelsData.accept(result.novels)
                self.resultCount.accept(result.resultCount)
                self.isLoadable = result.isLoadable
                self.showLoadingView.accept(false)
            }, onError: { error in
                print("Error fetching novels: \(error)")
                self.showLoadingView.accept(false)
            })
            .disposed(by: disposeBag)
        
        filteredNovelsData
            .map { $0.isEmpty }
            .bind(to: showEmptyView)
            .disposed(by: disposeBag)
        
        input.novelCollectionViewReachedBottom
            .filter { reachedBottom in
                return reachedBottom && !self.isFetching && self.isLoadable
            }
            .do(onNext: { _ in
                self.isFetching = true
            })
            .flatMapLatest { _ in
                self.getDetailSearchNovels(
                    genres: self.genres.map { $0.rawValue },
                    isCompleted: self.isCompleted,
                    novelRating: self.novelRating,
                    keywordIds: self.keywords.map { $0.keywordId },
                    page: self.currentPage + 1)
                .do(onNext: { _ in
                    self.currentPage += 1
                    self.isFetching = false
                }, onError: { _ in
                    self.isFetching = false
                })
            }
            .subscribe(with: self, onNext: { owner, data in
                let newData = owner.filteredNovelsData.value + data.novels
                owner.filteredNovelsData.accept(newData)
                owner.isLoadable = data.isLoadable
            })
            .disposed(by: disposeBag)
        
        input.updateDetailSearchResultNotification
            .do(onNext: { _ in
                self.showLoadingView.accept(true)
            })
            .subscribe(with: self, onNext: { owner, notification in
                owner.updateDetailSearchResultNotification.accept(notification)
                owner.filteredNovelsData.accept([])
                
                if let userInfo = notification.userInfo {
                    let keywords = userInfo["keywords"] as? [KeywordData]
                    let genres = userInfo["genres"] as? [NovelGenre]
                    let isCompleted = userInfo["isCompleted"] as? Bool
                    let novelRating = userInfo["novelRating"] as? Float
                    
                    owner.keywords = keywords ?? []
                    owner.genres = genres ?? []
                    owner.isCompleted = isCompleted
                    owner.novelRating = novelRating
                    owner.currentPage = 0
                    
                    owner.getDetailSearchNovels(
                        genres: owner.genres.map { $0.rawValue },
                        isCompleted: owner.isCompleted,
                        novelRating: owner.novelRating,
                        keywordIds: owner.keywords.map { $0.keywordId },
                        page: 0
                    )
                    .subscribe(onNext: { result in
                        owner.filteredNovelsData.accept(result.novels)
                        owner.resultCount.accept(result.resultCount)
                        owner.isLoadable = result.isLoadable
                        owner.showLoadingView.accept(false)
                    }, onError: { error in
                        print("Error fetching novels: \(error)")
                        owner.showLoadingView.accept(false)
                    })
                    .disposed(by: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(popViewController: popViewController.asObservable(),
                      novelCollectionViewHeight: novelCollectionViewHeight.asObservable(),
                      pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
                      presentDetailSearchModal: presentDetailSearchModal.asObservable(),
                      filteredNovelsData: filteredNovelsData.asObservable(),
                      resultCount: resultCount.asDriver(),
                      showEmptyView: showEmptyView.asObservable(),
                      showLoadingView: showLoadingView.asObservable())
    }
    
    //MARK: - API
    
    private func getDetailSearchNovels(genres: [String],
                                       isCompleted: Bool?,
                                       novelRating: Float?,
                                       keywordIds: [Int],
                                       page: Int) -> Observable<DetailSearchNovels> {
        searchRepository.getDetailSearchNovels(genres: genres,
                                               isCompleted: isCompleted,
                                               novelRating: novelRating,
                                               keywordIds: keywordIds,
                                               page: page)
    }
}

struct SearchFilterQuery {
    let keywords: [KeywordData]
    let genres: [NovelGenre]
    let isCompleted: Bool?
    let novelRating: Float?
}
