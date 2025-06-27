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
    
    //Constant
    let size = 20
    
    //Rx
    let filterOption = BehaviorRelay<LibraryFilterOption>(value: LibraryFilterOption())
    private let sortType = BehaviorRelay<SortType>(value: .newest)
    private let layoutType = BehaviorRelay<LayoutType>(value: .grid)
    private let novelCount = BehaviorRelay<Int>(value: 0)
    
    private let libraryNovelList = BehaviorRelay<[MyLibraryEntity]>(value: [])
    private let lastUserNovelId = BehaviorRelay<Int>(value: 0)
    private let updateData = PublishRelay<Void>()
    private let reloadData = PublishRelay<Void>()
    private let isFetching = BehaviorRelay<Bool>(value: false)
    private let isLoadable = BehaviorRelay<Bool>(value: true)
    
    private let showEmptyLibraryView = PublishRelay<Bool>()
    
    
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
    }
    
    struct Output {
        let selectedFilterOption: Driver<LibraryFilterOption>
        let selectedSortType: Driver<SortType>
        let selectedLayoutType: Driver<LayoutType>
        let libraryNovelList: Observable<[MyLibraryEntity]>
        let showEmptyLibraryView: Observable<Bool>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        
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
            .bind(to: reloadData)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .bind(to: reloadData)
            .disposed(by: disposeBag)
        
        reloadData
            .bind(with: self, onNext: { owner, _ in
                owner.libraryNovelList.accept([])
                owner.isLoadable.accept(true)
                owner.novelCount.accept(0)
                owner.lastUserNovelId.accept(0)
                owner.updateData.accept(())
            })
            .disposed(by: disposeBag)
        
        updateData
            .withLatestFrom(Observable.combineLatest(isFetching, isLoadable))
            .filter { !($0.0) && $0.1 }
            .do(onNext: { [weak self] _ in self?.isFetching.accept(true) })
            .withLatestFrom(Observable.combineLatest(filterOption, lastUserNovelId, sortType))
            .flatMapLatest { (filterOption, lastUserNovelId, sortType) in
                self.getNovelListData(filterOption: filterOption,
                                      lastUserNovelId: lastUserNovelId,
                                      sortType: sortType)
            }
            .withLatestFrom(libraryNovelList) { ($0, $1) }
            .bind(with: self, onNext: { owner, data in
                let (entity, currentList) = data
                let newList = currentList + entity.userNovels
                owner.libraryNovelList.accept(newList)
                owner.isLoadable.accept(entity.isLoadable)
                owner.novelCount.accept(entity.userNovelCount)
                owner.lastUserNovelId.accept(entity.userNovels.last?.userNovelId ?? 0)
                owner.isFetching.accept(false)
                owner.showEmptyLibraryView.accept(newList.isEmpty)
            })
            .disposed(by: disposeBag)
        
        return Output(
            selectedFilterOption: filterOption.asDriver(),
            selectedSortType: sortType.asDriver(),
            selectedLayoutType: layoutType.asDriver(),
            libraryNovelList: libraryNovelList.asObservable(),
            showEmptyLibraryView: showEmptyLibraryView.asObservable()
        )
    }
    
    //MARK: - API
    
    private func getNovelListData(filterOption: LibraryFilterOption, lastUserNovelId: Int, sortType: SortType) -> Observable<MyLibraryListEntity> {
        return self.myLibraryRepository.getNovelList(
            filterOption: filterOption,
            lastUserNovelId: lastUserNovelId,
            size: self.size,
            sortType: sortType
        )
        .asObservable()
        .catch { [weak self] error in
            print(error)
            self?.isFetching.accept(false)
            return Observable.empty()
        }
    }
    
    //MARK: - Custom Method
    
    
}
