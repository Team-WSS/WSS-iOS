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
    weak var delegate: NovelDelegate?
    private var isMyPage = true
    
    private let disposeBag = DisposeBag()
    
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
    private let updateCollectionViewWithLoadTriggerRelay = PublishRelay<ShowNovelStatus>()
    private let updateCollectionViewWithoutLoadTriggerRelay = PublishRelay<ShowNovelStatus>()
    private let isSortTypeNewestRelay = BehaviorRelay<Bool>(value: true)
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
        
        let listTapped: ControlEvent<Void>
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
        let showListView: BehaviorRelay<Bool>
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
        
        input.loadNextPageTrigger
            .filter { [unowned self] _ in !self.isFetching && self.isLoadableRelay.value }
            .do(onNext: { [unowned self] _ in self.isFetching = true })
            .flatMapLatest { [unowned self] _ in
                self.getUserNovelList(userId: self.userId,
                                      data: ShowNovelStatus(readStatus: self.initData.readStatus,
                                                            lastUserNovelId: self.lastNovelIdRelay.value,
                                                            size: self.initData.size,
                                                            sortType: self.initData.sortType))
            }
            .subscribe(with: self, onNext: { owner, novelResult in
                owner.setNovelListData(novelResult)
            }, onError: { owner, error in
                owner.isFetching = false
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        input.listTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                let currentValue = owner.showListViewRelay.value
                self.showListViewRelay.accept(!currentValue)
            })
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.newestTapped
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .filter { [unowned self] _ in !self.isSortTypeNewestRelay.value }
                .map { ("newest", true) },
            input.oldestTapped
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .filter { [unowned self] _ in self.isSortTypeNewestRelay.value }
                .map { ("oldest", false) }
        )
        .do(onNext: { [unowned self] sortType, isNewest in
            self.isSortTypeNewestRelay.accept(isNewest)
            self.showListViewRelay.accept(false)
        })
        .map { [unowned self] sortType, _ in
            ShowNovelStatus(
                readStatus: self.initData.readStatus,
                lastUserNovelId: sortType == "newest" ? 0 : self.showNovelTotalCountRelay.value,
                size: self.initData.size,
                sortType: sortType
            )
        }
        .withLatestFrom(isNotLoadableRelay) { novelStatus, isNotLoadable in
            return (novelStatus, isNotLoadable)
        }
        .subscribe(onNext: { [unowned self] novelStatus, isNotLoadable in
            if isNotLoadable {
                self.updateCollectionViewWithoutLoadTriggerRelay.accept(novelStatus)
            } else {
                self.novelDataRelay.accept([])
                self.updateCollectionViewWithLoadTriggerRelay.accept(novelStatus)
            }
        })
        .disposed(by: disposeBag)
        
        updateCollectionViewWithLoadTriggerRelay
            .filter { [unowned self] _ in !self.isFetching && self.isLoadableRelay.value }
            .do(onNext: { [unowned self] _ in
                self.isFetching = true
            })
            .flatMapLatest { [unowned self] status in
                self.getUserNovelList(userId: self.userId, data: status)
                    .map { novelResult -> UserNovelList in
                        if status.sortType == "oldest" {
                            
                            var reversedNovels = novelResult.userNovels
                            reversedNovels.reverse()
                            
                            return UserNovelList(
                                userNovelCount: novelResult.userNovelCount,
                                userNovelRating: novelResult.userNovelRating,
                                isLoadable: novelResult.isLoadable,
                                userNovels: reversedNovels
                            )
                        }
                        
                        return novelResult
                    }
            }
            .subscribe(with: self, onNext: { owner, novelResult in
                owner.updateNovelListWithNewSortTypeWithLoadTrigger(novelResult)
            }, onError: { owner, error in
                owner.isFetching = false
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
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
                      showListView: self.showListViewRelay,
                      updateToggleViewTitle: self.isSortTypeNewestRelay,
                      reloadCollectionView: self.reloadCollectionViewRelay)
    }
    
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
    
    private func updateNovelListWithNewSortTypeWithLoadTrigger(_ novelResult: UserNovelList) {
        let newNovelData = novelResult.userNovels
        if let lastNovel = novelResult.userNovels.last {
            self.lastNovelIdRelay.accept(Int(lastNovel.userNovelId))
        }
        
        self.novelDataRelay.accept(self.novelDataRelay.value + newNovelData)
        self.isLoadableRelay.accept(novelResult.isLoadable)
        self.isFetching = false
    }
    
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
