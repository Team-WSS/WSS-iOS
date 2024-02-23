//
//  RecordViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 2/19/24.
//

import Foundation

import RxSwift
import RxCocoa

final class RecordViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let memoRepository: DefaultMemoRepository
    private let disposeBag = DisposeBag()
    
    var recordMemoList = BehaviorRelay<[RecordMemo]>(value: [])
    var recordMemoCount = BehaviorRelay<Int>(value: 0)
    
    var lastMemoId = StringLiterals.Alignment.newest.lastId
    var sortType = StringLiterals.Alignment.newest.sortType
    
    // MARK: - Inputs
    
    struct Input {
        let sortTypeButtonTapped: ControlEvent<Void>
        let newestButtonTapped: ControlEvent<Void>
        let oldestButtonTapped: ControlEvent<Void>
        let recordCellSelected: ControlEvent<IndexPath>
        let emptyButtonTapped: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let showAlignmentView = BehaviorRelay<Bool>(value: false)
        let alignNewest = BehaviorRelay<Bool>(value: false)
        let alignOldest = BehaviorRelay<Bool>(value: false)
        let navigateToMemoRead = PublishRelay<IndexPath>()
        let navigateEmptyView = BehaviorRelay<Bool>(value: false)
    }
    
    //MARK: - init
    
    init(memoRepository: DefaultMemoRepository) {
        self.memoRepository = memoRepository
    }
    
    //MARK: - API
    
    func getDataFromAPI(id: Int,
                        sortType: String) {
        memoRepository.getRecordMemos(lastId: id, sort: sortType)
            .subscribe(with: self, onNext: { owner, memo in
                owner.recordMemoCount.accept(memo.memoCount)
                owner.recordMemoList.accept(memo.memos)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Methods

extension RecordViewModel {
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.sortTypeButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                output.showAlignmentView.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.newestButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                owner.sortType = StringLiterals.Alignment.newest.sortType
                owner.lastMemoId = StringLiterals.Alignment.newest.lastId
                owner.getDataFromAPI(id: owner.lastMemoId, sortType: owner.sortType)
                output.alignNewest.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.oldestButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                owner.sortType = StringLiterals.Alignment.oldest.sortType
                owner.lastMemoId = StringLiterals.Alignment.oldest.lastId
                owner.getDataFromAPI(id: owner.lastMemoId, sortType: owner.sortType)
                output.alignOldest.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.recordCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                output.navigateToMemoRead.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        input.emptyButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                output.navigateEmptyView.accept(true)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
