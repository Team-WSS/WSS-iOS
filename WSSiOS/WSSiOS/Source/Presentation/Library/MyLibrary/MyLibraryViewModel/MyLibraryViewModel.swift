//
//  MyLibraryViewModel.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/25/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class MyLibraryViewModel: ViewModelType {
    
    //MARK: - Properties
    
    let myLibraryRepository: MyLibraryRepository
    
    //Rx
    let filterOption = BehaviorRelay<LibraryFilterOption>(value: LibraryFilterOption())
    private let sortType = BehaviorRelay<SortType>(value: .newest)
    private let layoutType = BehaviorRelay<LayoutType>(value: .grid)
    private let novelCount = BehaviorRelay<Int>(value: 0)
    
    private let libraryNovelList = BehaviorRelay<[MyLibraryNovel]>(value: [])
    private let lastUserNovelId = BehaviorRelay<Int>(value: 0)
    private let isFetching = BehaviorRelay<Bool>(value: false)
    private let isLoadable = BehaviorRelay<Bool>(value: true)
    private let fetchNovelList = PublishRelay<Void>()
    private let reloadNovelList = PublishRelay<Void>()
    private let refreshNovelList = PublishRelay<Void>()
    
    private let showEmptyLibraryView = BehaviorRelay<Bool>(value: false)
    private let pushToNovelDetailViewController = PublishRelay<Int>()
    private let showLoadingView = BehaviorRelay<Bool>(value: false)
    private let showNetworkErrorView = BehaviorRelay<Bool>(value: false)
    
    
    //MARK: - Life Cycle
    
    init(myLibraryRepository: MyLibraryRepository) {
        self.myLibraryRepository = myLibraryRepository
    }
    
    //MARK: - Transform
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let interestFilterButtonDidTap: ControlEvent<Void>
        let sortButtonDidTap: ControlEvent<Void>
        let layoutToggleButtonDidTap: ControlEvent<Void>
        let collectionViewDidReachBottom: Observable<Void>
        let tableViewDidReachBottom: Observable<Void>
        let novelItemSelected: Observable<IndexPath>
    }
    
    struct Output {
        let selectedFilterOption: Driver<LibraryFilterOption>
        let selectedSortType: Driver<SortType>
        let selectedLayoutType: Driver<LayoutType>
        let novelCount: Driver<Int>
        let libraryNovelList: Observable<[MyLibraryNovel]>
        let showEmptyLibraryView: Observable<Bool>
        let pushToNovelDetailViewController: Observable<Int>
        let showLoadingView: Observable<Bool>
        let showNetworkErrorView: Observable<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        input.viewWillAppear
            .skip(1)
            .bind(to: refreshNovelList)
            .disposed(by: disposeBag)
        
        input.interestFilterButtonDidTap
            .withLatestFrom(filterOption)
            .map { option in
                var updated = option
                updated.interestedOption.toggle()
                return updated
            }
            .bind(to: filterOption)
            .disposed(by: disposeBag)
        
        input.sortButtonDidTap
            .withLatestFrom(sortType)
            .map { $0.toggle() }
            .bind(to: sortType)
            .disposed(by: disposeBag)
        
        input.layoutToggleButtonDidTap
            .withLatestFrom(layoutType)
            .map { $0.toggle() }
            .bind(to: layoutType)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(filterOption, sortType)
            .observe(on: MainScheduler.asyncInstance)  // raceCondition을 방지하기 위해 한사이클 다음에 스트림이 작동하도록 하는 역할.
            .map { _ in }
            .bind(to: reloadNovelList)
            .disposed(by: disposeBag)
        
        Observable.merge(
            input.collectionViewDidReachBottom,
            input.tableViewDidReachBottom
        )
        .bind(to: fetchNovelList)
        .disposed(by: disposeBag)
        
        reloadNovelList
            .bind(with: self, onNext: { owner, _ in
                owner.initializeLibraryState()
                owner.isFetching.accept(false)
                owner.fetchNovelList.accept(())
            })
            .disposed(by: disposeBag)
        
        fetchNovelList
            .withLatestFrom(Observable.combineLatest(isFetching, isLoadable))
            .filter { !$0.0 && $0.1 }
            .withLatestFrom(libraryNovelList)
            .do(onNext: { [weak self] in self?.updateRequestState(isStarting: true, isReloading: $0.isEmpty)})
            .withLatestFrom(Observable.combineLatest(filterOption, lastUserNovelId, sortType))
            .flatMapLatest { (filterOption, lastUserNovelId, sortType) in
                self.getNovelListData(filterOption: filterOption,
                                      lastUserNovelId: lastUserNovelId,
                                      sortType: sortType)
            }
            .do(onNext: { [weak self] _ in self?.updateRequestState(isStarting: false)})
            .withLatestFrom(libraryNovelList) { entity, currentList in
                var updatedEntity = entity
                updatedEntity.userNovels = currentList + entity.userNovels
                return updatedEntity
            }
            .bind(with: self, onNext: { owner, entity in
                owner.updateLibraryState(with: entity)
            })
            .disposed(by: disposeBag)
        
        refreshNovelList
            .withLatestFrom(isFetching)
            .filter { !$0 }
            .do(onNext: { [weak self] _ in self?.updateRequestState(isStarting: true)})
            .withLatestFrom(Observable.combineLatest(filterOption, sortType, libraryNovelList))
            .flatMapLatest { (filterOption, sortType, novelList) in
                let size = novelList.count == 0 ? 12 : novelList.count
                return self.getNovelListData(filterOption: filterOption,
                                      lastUserNovelId: 0,
                                      size: size,
                                      sortType: sortType)
            }
            .do(onNext: { [weak self] _ in self?.updateRequestState(isStarting: false)})
            .bind(with: self, onNext: { owner, entity in
                owner.updateLibraryState(with: entity)
            })
            .disposed(by: disposeBag)
        
        input.novelItemSelected
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(libraryNovelList) { indexPath, novelList in
                novelList[indexPath.item].novelId
            }
            .bind(to: pushToNovelDetailViewController)
            .disposed(by: disposeBag)
        
        return Output(
            selectedFilterOption: filterOption.asDriver(),
            selectedSortType: sortType.asDriver(),
            selectedLayoutType: layoutType.asDriver(),
            novelCount: novelCount.asDriver(),
            libraryNovelList: libraryNovelList.asObservable(),
            showEmptyLibraryView: showEmptyLibraryView.asObservable(),
            pushToNovelDetailViewController: pushToNovelDetailViewController.asObservable(),
            showLoadingView: showLoadingView.asObservable(),
            showNetworkErrorView: showNetworkErrorView.asObservable()
        )
    }
    
    //MARK: - API
    
    private func getNovelListData(filterOption: LibraryFilterOption, lastUserNovelId: Int, size: Int = 12, sortType: SortType) -> Observable<MyLibraryEntity> {
        return self.myLibraryRepository.getNovelList(
            filterOption: filterOption,
            lastUserNovelId: lastUserNovelId,
            size: size,
            sortType: sortType
        )
        .asObservable()
        .catch({ [weak self] error in
            self?.updateRequestState(isStarting: false, isError: true)
            print(error)
            return Observable.empty()
        })
    }
    
    //MARK: - Custom Method
    
    private func initializeLibraryState() {
        libraryNovelList.accept([])
        isLoadable.accept(true)
        novelCount.accept(0)
        lastUserNovelId.accept(0)
        showEmptyLibraryView.accept(false)
    }
    
    private func updateLibraryState(with entity: MyLibraryEntity) {
        libraryNovelList.accept(entity.userNovels)
        isLoadable.accept(entity.isLoadable)
        novelCount.accept(entity.userNovelCount)
        lastUserNovelId.accept(entity.userNovels.last?.userNovelId ?? 0)
        showEmptyLibraryView.accept(entity.userNovels.isEmpty)
    }
    
    private func updateRequestState(isStarting: Bool, isReloading: Bool = false, isError: Bool = false) {
        if isStarting {
            isFetching.accept(true)
            showNetworkErrorView.accept(false)
            showLoadingView.accept(isReloading)
        } else {
            isFetching.accept(false)
            showNetworkErrorView.accept(isError)
            showLoadingView.accept(false)
        }
    }
}
