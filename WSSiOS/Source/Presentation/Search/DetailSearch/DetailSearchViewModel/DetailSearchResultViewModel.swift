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

    // 검색 필터 옵션
    var option: SearchFilterQuery
    let entryType: EntryType

    // 무한 스크롤
    private var currentPage: Int = 0
    private var isLoadable: Bool = false
    private var isFetching: Bool = false
    
    // Output
    private let popViewController = PublishRelay<Void>()
    private let novelCollectionViewHeight = BehaviorRelay<CGFloat>(value: 0)
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let showEmptyView = PublishRelay<Bool>()
    
    private let filteredNovelsData = BehaviorRelay<[SearchNovel]>(value: [])
    private let resultCount = BehaviorRelay<Int>(value: 0)
    private let showLoadingView = PublishRelay<Bool>()
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
        let novelCollectionViewContentSize: Observable<CGSize?>
        let novelResultCellSelected: ControlEvent<IndexPath>
        let viewDidLoadEvent: Observable<Void>
        let novelCollectionViewReachedBottom: Observable<Bool>
        let searchBarViewDidTap: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let popViewController: Observable<Void>
        let novelCollectionViewHeight: Observable<CGFloat>
        let pushToNovelDetailViewController: Observable<Int>
        let filteredNovelsData: Observable<[SearchNovel]>
        let resultCount: Driver<Int>
        let showEmptyView: Observable<Bool>
        let showLoadingView: Observable<Bool>
    }
    
    init(searchRepository: SearchRepository,
         option: SearchFilterQuery,
         entryType: EntryType) {
        self.searchRepository = searchRepository
        self.option = option
        self.entryType = entryType
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
        
        input.viewDidLoadEvent
            .do(onNext: {
                self.showLoadingView.accept(true)
            })
            .flatMapLatest {
                return self.getDetailSearchNovels(
                    genres: self.option.genres.map { $0.rawValue },
                    platforms: self.option.platforms.map { $0.title },
                    isCompleted: self.option.isCompleted,
                    lowerNovelRating: self.option.lowerNovelRating,
                    upperNovelRating: self.option.upperNovelRating,
                    keywordIds: self.option.keywords.map { $0.keywordId },
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
                    genres: self.option.genres.map { $0.rawValue },
                    platforms: self.option.platforms.map { $0.title },
                    isCompleted: self.option.isCompleted,
                    lowerNovelRating: self.option.lowerNovelRating,
                    upperNovelRating: self.option.upperNovelRating,
                    keywordIds: self.option.keywords.map { $0.keywordId },
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
        
        input.searchBarViewDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.popViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(popViewController: popViewController.asObservable(),
                      novelCollectionViewHeight: novelCollectionViewHeight.asObservable(),
                      pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
                      filteredNovelsData: filteredNovelsData.asObservable(),
                      resultCount: resultCount.asDriver(),
                      showEmptyView: showEmptyView.asObservable(),
                      showLoadingView: showLoadingView.asObservable())
    }
    
    //MARK: - API
    
    private func getDetailSearchNovels(genres: [String],
                                       platforms: [String],
                                       isCompleted: Bool?,
                                       lowerNovelRating: Float,
                                       upperNovelRating: Float,
                                       keywordIds: [Int],
                                       page: Int) -> Observable<DetailSearchNovels> {
        searchRepository.getDetailSearchNovels(genres: genres,
                                               platforms: platforms,
                                               isCompleted: isCompleted,
                                               lowerNovelRating: lowerNovelRating,
                                               upperNovelRating: upperNovelRating,
                                               keywordIds: keywordIds,
                                               page: page)
    }
}

extension DetailSearchResultViewModel {
    enum EntryType {
        case fullOption
        case genreOnly
        case keywordOnly

        var placeholder: String {
            switch self {
            case .fullOption: return StringLiterals.DetailSearch.applyOption
            case .genreOnly: return StringLiterals.DetailSearch.applyGenre
            case .keywordOnly: return StringLiterals.DetailSearch.applyKeyword
            }
        }
    }
}
