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
    private let showLoadingViewRelay = BehaviorRelay<Bool>(value: false)
    
    private let showEmptyView = PublishRelay<(Bool,Bool)>()
    private let pushToDetailNovelViewController = PublishRelay<Int>()
    private let pushToSearchViewController = PublishRelay<Void>()
    private let sendNovelTotalCountRelay = BehaviorRelay<Int>(value: 0)
    
    private let showListViewRelay = BehaviorRelay<Bool>(value: false)
    private let updateCollectionViewRelay = BehaviorRelay<ShowNovelStatus>(value: ShowNovelStatus(readStatus: "", lastUserNovelId: 0, size: 0, sortType: ""     ))
    private let isSortTypeNewestRelay = BehaviorRelay<Bool>(value: true)

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
        let updateCollectionView: Observable<Void>
        
        let listTapped: ControlEvent<Void>
        let newestTapped: ControlEvent<Void>
        let oldestTapped: ControlEvent<Void>
    }
    
    struct Output {
        let cellData: BehaviorRelay<[UserNovel]>
        let showEmptyView: PublishRelay<(Bool,Bool)>
        let pushToDetailNovelViewController: PublishRelay<Int>
        let pushToSearchViewController: PublishRelay<Void>
        let sendNovelTotalCount: BehaviorRelay<Int>
        
        let showListView: BehaviorRelay<Bool>
        let updateToggleViewTitle: BehaviorRelay<Bool>
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
                owner.updateNovelList(novelResult)
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
        
        input.newestTapped
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .filter { [unowned self] _ in !self.isSortTypeNewestRelay.value }
            .do(onNext: { [unowned self] _ in
                self.isSortTypeNewestRelay.accept(true)
                self.showListViewRelay.accept(false)
            })
            .map { [unowned self] _ in
                ShowNovelStatus(
                    readStatus: self.initData.readStatus,
                    lastUserNovelId: 0,
                    size: self.initData.size,
                    sortType: "newest"
                )
            }
            .bind(to: updateCollectionViewRelay)
            .disposed(by: disposeBag)

            input.oldestTapped
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
                .filter { [unowned self] _ in self.isSortTypeNewestRelay.value }
                .do(onNext: { [unowned self] _ in
                    self.isSortTypeNewestRelay.accept(false)
                    self.showListViewRelay.accept(false)
                })
                .map { [unowned self] _ in
                    ShowNovelStatus(
                        readStatus: self.initData.readStatus,
                        lastUserNovelId: 0,
                        size: self.initData.size,
                        sortType: "oldest"
                    )
                }
                .bind(to: updateCollectionViewRelay)
                .disposed(by: disposeBag)

            updateCollectionViewRelay
                .filter { [unowned self] _ in !self.isFetching && self.isLoadableRelay.value }
                .do(onNext: { [unowned self] _ in
                    self.isFetching = true
                    self.novelDataRelay.accept([])
                })
                .flatMapLatest { [unowned self] status in
                    self.getUserNovelList(userId: self.userId, data: status)
                }
                .subscribe(with: self, onNext: { owner, novelResult in
                    owner.reupdateNovelList(novelResult)
                }, onError: { owner, error in
                    owner.isFetching = false
                    print(error.localizedDescription)
                })
                .disposed(by: disposeBag)
        
        return Output(cellData: self.novelDataRelay,
                      showEmptyView: self.showEmptyView,
                      pushToDetailNovelViewController: self.pushToDetailNovelViewController,
                      pushToSearchViewController: self.pushToSearchViewController,
                      sendNovelTotalCount: self.sendNovelTotalCountRelay,
                      showListView: self.showListViewRelay,
                      updateToggleViewTitle: self.isSortTypeNewestRelay)
    }
    
    private func updateNovelList(_ novelResult: UserNovelList) {
        let newNovelData = novelResult.userNovels
        if let lastNovel = novelResult.userNovels.last {
            self.lastNovelIdRelay.accept(Int(lastNovel.userNovelId))
        }
        
        self.novelDataRelay.accept(self.novelDataRelay.value + newNovelData)
        self.isLoadableRelay.accept(novelResult.isLoadable)
        self.isFetching = false
        
        self.showEmptyView.accept((novelDataRelay.value.isEmpty, self.isMyPage))
        
        self.sendNovelTotalCountRelay.accept(Int(novelResult.userNovelCount))
    }
    
    //TODO: size 보다 값이 작으면 update 하지 못함
    private func reupdateNovelList(_ novelResult: UserNovelList) {
        let newNovelData = novelResult.userNovels
        if let lastNovel = novelResult.userNovels.last {
            self.lastNovelIdRelay.accept(Int(lastNovel.userNovelId))
        }
        
        self.novelDataRelay.accept(self.novelDataRelay.value + newNovelData)
        self.isLoadableRelay.accept(novelResult.isLoadable)
        self.isFetching = false
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
