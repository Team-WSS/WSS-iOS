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
    
    let filterOption = BehaviorRelay<LibraryFilterOption>(value: LibraryFilterOption())
    private let sortType = BehaviorRelay<SortType>(value: .newest)
    private let libraryCollectionViewHeight = PublishRelay<CGFloat>()
    private let libraryTableViewHeight = PublishRelay<CGFloat>()
    private let libraryNovelList = BehaviorRelay<[MyLibraryListEntity]>(value: [])
    private let loadData = PublishRelay<Void>()
    private let lastFeedId = BehaviorRelay<Int>(value: 0)
    private let isFetching = BehaviorRelay<Bool>(value: false)
    private let isLoadable = BehaviorRelay<Bool>(value: true)
    
    //MARK: - Life Cycle
    
    
    //MARK: - Transform
    
    struct Input {
        let interestFilterButtonDidTap: ControlEvent<Void>
        let sortButtonDidTap: ControlEvent<Void>
        let libraryCollectionViewContentSize: Observable<CGSize?>
        let libraryTableViewContentSize: Observable<CGSize?>
    }
    
    struct Output {
        let selectedFilterOption: Driver<LibraryFilterOption>
        let selectedSortType: Driver<SortType>
        let libraryCollectionViewHeight: Observable<CGFloat>
        let libraryTableViewHeight: Observable<CGFloat>
        let libraryNovelList: Driver<[MyLibraryListEntity]>
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
        
        input.libraryCollectionViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: libraryCollectionViewHeight)
            .disposed(by: disposeBag)
        
        input.libraryTableViewContentSize
            .map { $0?.height ?? 0 }
            .bind(to: libraryTableViewHeight)
            .disposed(by: disposeBag)
        
        return Output(
            selectedFilterOption: filterOption.asDriver(),
            selectedSortType: sortType.asDriver(),
            libraryCollectionViewHeight: libraryCollectionViewHeight.asObservable(),
            libraryTableViewHeight: libraryTableViewHeight.asObservable(),
            libraryNovelList: libraryNovelList.asDriver()
        )
    }
    
    //MARK: - API
    
    private func getNovelListData(disposeBag: DisposeBag) {
        
    }
    
    //MARK: - Custom Method
    
    
}
