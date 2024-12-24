//
//  LibraryChildViewModel.swift
//  WSSiOS
//
//  Created by 신지원 on 12/1/24.
//

import Foundation

import RxSwift
import RxCocoa

protocol NovelDelegate: AnyObject {
    func sendNovelCount(data: Int)
}

final class LibraryChildViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let userRepository: UserRepository
    private let initData: ShowNovelStatus
    private let userId: Int
    
    private let disposeBag = DisposeBag()
    
    private var isMyPage = true
    private var isFetching = false
    private var isSortTypeNewest = true
    
    private let novelDataRelay = BehaviorRelay<[UserNovel]>(value: [])
    private let isLoadableRelay = BehaviorRelay<Bool>(value: true)
    private let lastNovelIdRelay = BehaviorRelay<Int>(value: 0)
    
    private let showEmptyView = PublishRelay<(Bool,Bool)>()
    
    private let pushToDetailNovelViewController = PublishRelay<Int>()
    private let pushToSearchViewController = PublishRelay<Void>()
    
    private let showNovelTotalCountRelay = BehaviorRelay<Int>(value: 0)
    private let showListViewRelay = BehaviorRelay<Bool>(value: false)
    private let isSortTypeNewestRelay = BehaviorRelay<Bool>(value: true)
    
    private let updateCollectionViewWithLoadTriggerRelay = PublishRelay<ShowNovelStatus>()
    private let updateCollectionViewWithoutLoadTriggerRelay = PublishRelay<ShowNovelStatus>()
    
    private let isNotLoadableRelay = BehaviorRelay<Bool>(value: false)
    private let reloadCollectionViewRelay = PublishRelay<Void>()
    
    // MARK: - Life Cycle
    
    init(userRepository: UserRepository, initData: ShowNovelStatus, userId: Int) {
        self.userRepository = userRepository
        self.initData = initData
        self.userId = userId
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let lookForNovelButtonDidTap: ControlEvent<Void>
        let cellItemSeleted: ControlEvent<IndexPath>
        let loadNextPageTrigger: Observable<Void>
        
        let dropdownListDidTap: ControlEvent<Void>
        let newestTapped: ControlEvent<Void>
        let oldestTapped: ControlEvent<Void>
    }
    
    struct Output {
        
        //collectionView Data
        let cellData: BehaviorRelay<[UserNovel]>
        let showEmptyView: PublishRelay<(Bool,Bool)>
        
        //Logic
        let pushToDetailNovelViewController: PublishRelay<Int>
        let pushToNormalSearchViewController: PublishRelay<Void>
        
        //Page descriptionView Data
        let showNovelTotalCount: BehaviorRelay<Int>
        let showDropdownListView: BehaviorRelay<Bool>
        let updateToggleViewTitle: BehaviorRelay<Bool>
        let reloadCollectionView: PublishRelay<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
        let userDefaultId = UserDefaults.standard.integer(forKey: StringLiterals.UserDefault.userId)
        self.isMyPage = self.userId == userDefaultId
        
        input.lookForNovelButtonDidTap
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                self.pushToSearchViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.cellItemSeleted
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, indexPath in
                let novelList = self.novelDataRelay.value
                let novelId = novelList[indexPath.row].novelId
                self.pushToDetailNovelViewController.accept(Int(novelId))
            })
            .disposed(by: disposeBag)
        
        //무한스크롤 구현
        input.loadNextPageTrigger
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return !self.isFetching && self.isLoadableRelay.value
            }
            .do(onNext: { [weak self] _ in
                self?.isFetching = true
            })
            .flatMapLatest { [weak self] _ -> Observable<UserNovelList> in
                guard let self else { return .empty() }
                return self.getUserNovelList(userId: self.userId,
                                             data: ShowNovelStatus(readStatus: self.initData.readStatus,
                                                                   lastUserNovelId: self.lastNovelIdRelay.value,
                                                                   size: self.initData.size,
                                                                   sortType: isSortTypeNewestRelay.value ? "NEWEST" : "OLDEST"))
            }
            .subscribe(with: self, onNext: { owner, novelResult in
                owner.setNovelListData(novelResult)
            }, onError: { owner, error in
                owner.isFetching = false
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.dropdownListDidTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                let currentValue = owner.showListViewRelay.value
                self.showListViewRelay.accept(!currentValue)
            })
            .disposed(by: disposeBag)
        
        //변경된 sortList 로 서버 호출하기 위한 데이터 세팅
        Observable.merge(
            input.newestTapped
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .filter { [weak self] _ in
                    guard let self = self else { return false }
                    return !self.isSortTypeNewestRelay.value
                }
                .map { ("newest", true) },
            input.oldestTapped
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .filter { [weak self] _ in
                    guard let self = self else { return false }
                    return self.isSortTypeNewestRelay.value
                }
                .map { ("oldest", false) }
        )
        .do(onNext: { [weak self] sortType, isNewest in
            self?.isSortTypeNewestRelay.accept(isNewest)
            self?.showListViewRelay.accept(false)
            self?.lastNovelIdRelay.accept(0)
        })
        .map { [weak self] sortType, _ -> ShowNovelStatus? in
            guard let self = self else { return nil }
            
            return ShowNovelStatus(
                readStatus: self.initData.readStatus,
                lastUserNovelId: self.lastNovelIdRelay.value,
                size: self.initData.size,
                sortType: sortType
            )
        }
        .compactMap { $0 }
        .withLatestFrom(isNotLoadableRelay) { novelStatus, isNotLoadable in
            return (novelStatus, isNotLoadable)
        }
        
        //작품 수가 size 보다 더 많은지 판별하여 무한스크롤 여부 처리
        .subscribe(onNext: { [weak self] novelStatus, isNotLoadable in
            guard let self = self else { return }
            if isNotLoadable {
                self.updateCollectionViewWithoutLoadTriggerRelay.accept(novelStatus)
            } else {
                self.novelDataRelay.accept([])
                self.isLoadableRelay.accept(!isNotLoadable)
                self.updateCollectionViewWithLoadTriggerRelay.accept(novelStatus)
            }
        })
        .disposed(by: disposeBag)
        
        //무한스크롤일 때 처리
        updateCollectionViewWithLoadTriggerRelay
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return !self.isFetching && self.isLoadableRelay.value
            }
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isFetching = true
            })
            .flatMapLatest { [weak self] status -> Observable<UserNovelList> in
                guard let self = self else { return .empty() }
                return self.getUserNovelList(userId: self.userId, data: status)
            }
            .subscribe(with: self, onNext: { owner, novelResult in
                owner.updateNovelListWithNewSortTypeWithLoadTrigger(novelResult)
            }, onError: { owner, error in
                owner.isFetching = false
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        //무한스크롤이 아닐 때 처리
        updateCollectionViewWithoutLoadTriggerRelay
            .subscribe(with: self, onNext: { owner, novelResult in
                owner.updateNovelListWithNewSortTypeWithoutLoadTrigger(novelResult)
            }, onError: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        return Output(cellData: self.novelDataRelay,
                      showEmptyView: self.showEmptyView,
                      pushToDetailNovelViewController: self.pushToDetailNovelViewController,
                      pushToNormalSearchViewController: self.pushToSearchViewController,
                      showNovelTotalCount: self.showNovelTotalCountRelay,
                      showDropdownListView: self.showListViewRelay,
                      updateToggleViewTitle: self.isSortTypeNewestRelay,
                      reloadCollectionView: self.reloadCollectionViewRelay)
    }
    
    // MARK: - Custom Method
    
    //가장 처음 호출되는 무한스크롤
    private func setNovelListData(_ novelResult: UserNovelList) {
        let newNovelData = novelResult.userNovels
        if let lastNovel = novelResult.userNovels.last {
            self.lastNovelIdRelay.accept(Int(lastNovel.userNovelId))
        }
        
        self.novelDataRelay.accept(self.novelDataRelay.value + newNovelData)
        self.isLoadableRelay.accept(novelResult.isLoadable)
        self.isFetching = false
        
        self.showEmptyView.accept((novelDataRelay.value.isEmpty, self.isMyPage))
        self.showNovelTotalCountRelay.accept(Int(novelResult.userNovelCount))
        if Int(novelResult.userNovelCount) <= self.initData.size {
            isNotLoadableRelay.accept(true)
        }
    }
    
    //무한스크롤이 가능한 경우 처리
    private func updateNovelListWithNewSortTypeWithLoadTrigger(_ novelResult: UserNovelList) {
        let newNovelData = novelResult.userNovels
        if let lastNovel = novelResult.userNovels.last {
            self.lastNovelIdRelay.accept(Int(lastNovel.userNovelId))
        }
        
        self.novelDataRelay.accept(self.novelDataRelay.value + newNovelData)
        self.isLoadableRelay.accept(novelResult.isLoadable)
        self.isFetching = false
        
        if Int(novelResult.userNovelCount) <= self.initData.size {
            isNotLoadableRelay.accept(true)
        }
    }
    
    //무한 스크롤이 불가능한 경우 처리
    private func updateNovelListWithNewSortTypeWithoutLoadTrigger(_ novelStatus: ShowNovelStatus) {
        var novelData = self.novelDataRelay.value
        novelData.reverse()
        self.novelDataRelay.accept(novelData)
    }
    
    // MARK: - API
    
    private func getUserNovelList(userId: Int, data: ShowNovelStatus) -> Observable<UserNovelList> {
        return userRepository.getUserNovelList(userId: userId,
                                               readStatus: data.readStatus,
                                               lastUserNovelId: data.lastUserNovelId,
                                               size: data.size,
                                               sortType: data.sortType)
        .asObservable()
    }
}
