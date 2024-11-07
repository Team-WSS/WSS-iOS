//
//  DetailSearchViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import RxRelay

final class DetailSearchViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let keywordRepository: KeywordRepository
    private let previousViewInfo: PreviousViewType
    private let selectedFilteredQuery: SearchFilterQuery
    
    // 전체
    private let dismissModalViewController = PublishRelay<Void>()
    let selectedTab = BehaviorRelay<DetailSearchTab>(value: DetailSearchTab.info)
    private let pushToDetailSearchResultViewControllerNotificationName = Notification.Name("PushToDetailSearchResult")
    private let pushToUpdateDetailSearchResultViewControllerNotificationName = Notification.Name("PushToUpdateDetailSearchResult")
    
    // 정보
    var selectedGenreList: [NovelGenre] = []
    let selectedGenreListData = BehaviorRelay<[NovelGenre]>(value: [])
    private let genreListData = PublishRelay<[NovelGenre]>()
    private var selectedCompletedStatus = BehaviorRelay<CompletedStatus?>(value: nil)
    private var selectedNovelRatingStatus = BehaviorRelay<NovelRatingStatus?>(value: nil)
    private let resetSelectedInfoData = PublishRelay<Void>()
    
    // 키워드
    var keywordSearchResultList: [KeywordData] = []
    var selectedKeywordList: [KeywordData]
    let keywordLimit: Int = 20
    
    private let enteredText = BehaviorRelay<String>(value: "")
    private let isKeywordTextFieldEditing = BehaviorRelay<Bool>(value: false)
    private let endEditing = PublishRelay<Void>()
    private let selectedKeywordListData = PublishRelay<[KeywordData]>()
    private let keywordSearchResultListData = PublishRelay<[KeywordData]>()
    private let keywordCategoryListData = PublishRelay<[KeywordCategory]>()
    private let isKeywordCountOverLimit = PublishRelay<IndexPath>()
    private let showEmptyView = PublishRelay<Bool>()
    private let showCategoryListView = PublishRelay<Bool>()
    
    struct Input {
        // 전체
        let viewDidLoadEvent: Observable<Void>
        let closeButtonDidTap: ControlEvent<Void>
        let infoTabDidTap: Observable<UITapGestureRecognizer>
        let keywordTabDidTap: Observable<UITapGestureRecognizer>
        let resetButtonDidTap: ControlEvent<Void>
        let searchNovelButtonDidTap: ControlEvent<Void>
        let updateDetailSearchResultData: Observable<Notification>
        
        // 정보
        let genreColletionViewItemSelected: Observable<IndexPath>
        let genreColletionViewItemDeselected: Observable<IndexPath>
        
        let completedButtonDidTap: Observable<CompletedStatus>
        let novelRatingButtonDidTap: Observable<NovelRatingStatus>
        
        // 키워드
        let updatedEnteredText: Observable<String>
        let keywordTextFieldEditingDidBegin: ControlEvent<Void>
        let keywordTextFieldEditingDidEnd: ControlEvent<Void>
        let keywordTextFieldEditingDidEndOnExit: ControlEvent<Void>
        let searchCancelButtonDidTap: ControlEvent<Void>
        let searchKeywordButtonDidTap: ControlEvent<Void>
        let selectedKeywordCollectionViewItemSelected: Observable<IndexPath>
        let searchResultCollectionViewItemSelected: Observable<IndexPath>
        let searchResultCollectionViewItemDeselected: Observable<IndexPath>
        let contactButtonDidTap: ControlEvent<Void>
        let selectedKeywordData: Observable<KeywordData>
        let deselectedKeywordData: Observable<KeywordData>
    }
    
    struct Output {
        // 전체
        let dismissModalViewController: Observable<Void>
        let selectedTab: Driver<DetailSearchTab>
        let showInfoNewImageView: Observable<Bool>
        let showKeywordNewImageView: Observable<Bool>
        
        // 정보
        let genreListData: Observable<[NovelGenre]>
        let selectedCompletedStatus: Driver<CompletedStatus?>
        let selectedNovelRatingStatus: Driver<NovelRatingStatus?>
        let resetSelectedInfoData: Observable<Void>
        
        // 키워드
        let enteredText: Observable<String>
        let isKeywordTextFieldEditing: Observable<Bool>
        let endEditing: Observable<Void>
        let selectedKeywordListData: Observable<[KeywordData]>
        let keywordSearchResultListData: Observable<[KeywordData]>
        let keywordCategoryListData: Observable<[KeywordCategory]>
        let isKeywordCountOverLimit: Observable<IndexPath>
        let showEmptyView: Observable<Bool>
        let showCategoryListView: Observable<Bool>
    }
    
    //MARK: - init
    
    init(keywordRepository: KeywordRepository,
         selectedKeywordList: [KeywordData],
         previousViewInfo: PreviousViewType,
         selectedFilteredQuery: SearchFilterQuery) {
        self.keywordRepository = keywordRepository
        self.selectedKeywordList = selectedKeywordList
        self.previousViewInfo = previousViewInfo
        self.selectedFilteredQuery = selectedFilteredQuery
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        // 전체
        input.viewDidLoadEvent
            .subscribe(with: self, onNext: { owner, _ in
                owner.genreListData.accept(NovelGenre.allCases)
                owner.selectedGenreListData.accept(owner.selectedFilteredQuery.genres)
                owner.selectedKeywordListData.accept(owner.selectedFilteredQuery.keywords)
                owner.selectedCompletedStatus.accept(owner.selectedFilteredQuery.isCompleted.map { CompletedStatus(isCompleted: $0) })
                owner.selectedNovelRatingStatus.accept(owner.selectedFilteredQuery.novelRating.map { NovelRatingStatus(toFloat: $0) })
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoadEvent
            .do(onNext: {
                self.selectedKeywordListData.accept(self.selectedKeywordList)
            })
            .flatMapLatest {
                self.searchKeyword()
            }
            .subscribe(with: self, onNext: { owner, data in
                owner.keywordCategoryListData.accept(data.categories)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.closeButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.infoTabDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.info)
            })
            .disposed(by: disposeBag)
        
        input.keywordTabDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.selectedTab.accept(.keyword)
            })
            .disposed(by: disposeBag)
        
        input.resetButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                // 정보뷰
                owner.selectedGenreList = []
                owner.selectedGenreListData.accept(owner.selectedGenreList)
                owner.resetSelectedInfoData.accept(())
                
                // 키워드뷰
                owner.selectedKeywordList = []
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
                owner.enteredText.accept("")
                owner.keywordSearchResultListData.accept([])
                owner.showEmptyView.accept(false)
                owner.showCategoryListView.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.searchNovelButtonDidTap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                let keywords = owner.selectedKeywordList
                let genres: [NovelGenre] = owner.selectedGenreListData.value
                let isCompleted = owner.selectedCompletedStatus.value?.isCompleted
                let novelRating = owner.selectedNovelRatingStatus.value?.toFloat
                
                let userInfo: [AnyHashable: Any] = [
                    "keywords": keywords,
                    "genres": genres,
                    "isCompleted": isCompleted as Any,
                    "novelRating": novelRating as Any
                ]
                
                if owner.previousViewInfo == .search {
                    NotificationCenter.default.post(name: owner.pushToDetailSearchResultViewControllerNotificationName,
                                                    object: nil,
                                                    userInfo: userInfo)
                    owner.dismissModalViewController.accept(())
                } else {
                    NotificationCenter.default.post(name: owner.pushToUpdateDetailSearchResultViewControllerNotificationName,
                                                    object: nil,
                                                    userInfo: userInfo)
                    owner.dismissModalViewController.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        input.genreColletionViewItemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.selectedGenreList = owner.selectedGenreListData.value
                owner.selectedGenreList.append(NovelGenre.allCases[indexPath.row])
                owner.selectedGenreListData.accept(owner.selectedGenreList)
            })
            .disposed(by: disposeBag)
        
        input.genreColletionViewItemDeselected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.selectedGenreList = owner.selectedGenreListData.value
                owner.selectedGenreList.removeAll { $0 == NovelGenre.allCases[indexPath.row] }
                owner.selectedGenreListData.accept(owner.selectedGenreList)
            })
            .disposed(by: disposeBag)
        
        input.completedButtonDidTap
            .subscribe(with: self, onNext: { owner, selectedCompletedStatus in
                if owner.selectedCompletedStatus.value == selectedCompletedStatus {
                    owner.selectedCompletedStatus.accept(nil)
                } else {
                    owner.selectedCompletedStatus.accept(selectedCompletedStatus)
                }
            })
            .disposed(by: disposeBag)
        
        input.novelRatingButtonDidTap
            .subscribe(with: self, onNext: { owner, selectedNovelRatingStatus in
                if owner.selectedNovelRatingStatus.value == selectedNovelRatingStatus {
                    owner.selectedNovelRatingStatus.accept(nil)
                } else {
                    owner.selectedNovelRatingStatus.accept(selectedNovelRatingStatus)
                }
            })
            .disposed(by: disposeBag)
        
        // 키워드
        input.updatedEnteredText
            .subscribe(with: self, onNext: { owner, text in
                owner.enteredText.accept(text)
            })
            .disposed(by: disposeBag)
        
        input.keywordTextFieldEditingDidBegin
            .subscribe(with: self, onNext: { owner, _ in
                owner.isKeywordTextFieldEditing.accept(true)
                owner.showEmptyView.accept(false)
                owner.showCategoryListView.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.keywordTextFieldEditingDidEnd
            .subscribe(with: self, onNext: { owner, _ in
                owner.isKeywordTextFieldEditing.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.searchCancelButtonDidTap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, _ in
                owner.enteredText.accept("")
                owner.showEmptyView.accept(false)
                owner.showCategoryListView.accept(true)
                owner.isKeywordTextFieldEditing.accept(false)
                owner.endEditing.accept(())
            })
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.keywordTextFieldEditingDidEndOnExit.asObservable(),
            input.searchKeywordButtonDidTap.asObservable()
        )
        .do(onNext: {
            self.endEditing.accept(())
        })
        .withLatestFrom(enteredText)
        .flatMapLatest { enteredText in
            if enteredText.isEmpty {
                return self.searchKeyword()
            } else {
                return self.searchKeyword(query: enteredText)
            }
        }
        .subscribe(with: self, onNext: { owner, data in
            print(data)
            if owner.enteredText.value.isEmpty {
                owner.keywordCategoryListData.accept(data.categories)
            } else {
                owner.keywordSearchResultList = data.categories.flatMap { $0.keywords }
                owner.keywordSearchResultListData.accept(owner.keywordSearchResultList)
            }
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
        
        input.selectedKeywordData
            .subscribe(with: self, onNext: { owner, keyword in
                owner.selectedKeywordList.append(keyword)
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
            })
            .disposed(by: disposeBag)
        
        input.deselectedKeywordData
            .subscribe(with: self, onNext: { owner, keyword in
                owner.selectedKeywordList.removeAll { $0.keywordName == keyword.keywordName }
                owner.selectedKeywordListData.accept(owner.selectedKeywordList)
            })
            .disposed(by: disposeBag)
        
        input.contactButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                if let url = URL(string: URLs.Contact.kakao) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        let showInfoNewImageView = Observable
            .combineLatest(
                selectedGenreListData.map { $0.count > 0 },
                selectedCompletedStatus.map { $0 != nil },
                selectedNovelRatingStatus.map { $0 != nil }
            )
            .map { $0 || $1 || $2 }
        
        let showKeywordNewImageView = selectedKeywordListData
            .map { $0.count > 0 }
            .asObservable()
        
        return Output(dismissModalViewController: dismissModalViewController.asObservable(),
                      selectedTab: selectedTab.asDriver(),
                      showInfoNewImageView: showInfoNewImageView,
                      showKeywordNewImageView: showKeywordNewImageView.asObservable(),
                      genreListData: genreListData.asObservable(),
                      selectedCompletedStatus: selectedCompletedStatus.asDriver(),
                      selectedNovelRatingStatus: selectedNovelRatingStatus.asDriver(),
                      resetSelectedInfoData: resetSelectedInfoData.asObservable(),
                      enteredText: enteredText.asObservable(),
                      isKeywordTextFieldEditing: isKeywordTextFieldEditing.asObservable(),
                      endEditing: endEditing.asObservable(),
                      selectedKeywordListData: selectedKeywordListData.asObservable(),
                      keywordSearchResultListData: keywordSearchResultListData.asObservable(),
                      keywordCategoryListData: keywordCategoryListData.asObservable(),
                      isKeywordCountOverLimit: isKeywordCountOverLimit.asObservable(),
                      showEmptyView: showEmptyView.asObservable(),
                      showCategoryListView: showCategoryListView.asObservable())
    }
    
    //MARK: - API
    
    private func searchKeyword(query: String? = nil) -> Observable<SearchKeywordResult> {
        keywordRepository.searchKeyword(query: query)
            .observe(on: MainScheduler.instance)
    }
}

enum PreviousViewType {
    case search
    case resultSearchBar
}
