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
    
    let filterOption = BehaviorRelay<LibraryFilterOption>(value: LibraryFilterOption())
    private let sortType = BehaviorRelay<SortType>(value: .newest)
    private let layoutType = BehaviorRelay<LayoutType>(value: .grid)
    private let libraryNovelList = BehaviorRelay<[MyLibraryListEntity]>(value: [])
    private let loadData = PublishRelay<Void>()
    private let lastFeedId = BehaviorRelay<Int>(value: 0)
    private let isFetching = BehaviorRelay<Bool>(value: false)
    private let isLoadable = BehaviorRelay<Bool>(value: true)
    
    //MARK: - Life Cycle
    
    init(myLibraryRepository: MyLibraryRepository) {
        self.myLibraryRepository = myLibraryRepository
    }
    
    //MARK: - Transform
    
    struct Input {
        let interestFilterButtonDidTap: ControlEvent<Void>
        let sortButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let selectedFilterOption: Driver<LibraryFilterOption>
        let selectedSortType: Driver<SortType>
        let selectedLayoutType: Driver<LayoutType>
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
        
        
        return Output(
            selectedFilterOption: filterOption.asDriver(),
            selectedSortType: sortType.asDriver(),
            selectedLayoutType: layoutType.asDriver(),
            libraryNovelList: libraryNovelList.asDriver()
        )
    }
    
    //MARK: - API
    
    private func getNovelListData(disposeBag: DisposeBag) {
        
    }
    
    //MARK: - Custom Method
    
    
}
