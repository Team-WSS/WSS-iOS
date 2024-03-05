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
    
    private var lastMemoId = StringLiterals.Alignment.newest.lastId
    private var sortType = StringLiterals.Alignment.newest.sortType
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let sortTypeButtonTapped: ControlEvent<Void>
        let newestButtonTapped: ControlEvent<Void>
        let oldestButtonTapped: ControlEvent<Void>
        let recordCellSelected: ControlEvent<IndexPath>
        let emptyButtonTapped: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        var recordMemoList = BehaviorRelay<[RecordMemo]>(value: [])
        var recordMemoCount = BehaviorRelay<Int>(value: 0)
        
        let showAlignmentView = PublishRelay<Bool>()
        let alignNewest = PublishRelay<Bool>()
        let alignOldest = PublishRelay<Bool>()
        let navigateToMemoRead = PublishRelay<IndexPath>()
        let navigateEmptyView = PublishRelay<Bool>()
    }
    
    //MARK: - init
    
    init(memoRepository: DefaultMemoRepository) {
        self.memoRepository = memoRepository
    }
    
    //MARK: - API
    
    private func getDataFromAPI(id: Int, sortType: String) -> Observable<RecordMemos> {
        memoRepository.getRecordMemos(lastId: id, sort: sortType)
            .observe(on: MainScheduler.instance)
    }
}

//MARK: - Methods

extension RecordViewModel {
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .flatMapLatest {
                self.getDataFromAPI(id: self.lastMemoId, sortType: self.sortType)
            }
            .subscribe(with: self, onNext: { owner, memo in
                output.recordMemoCount.accept(memo.memoCount)
                output.recordMemoList.accept(memo.memos)
            })
            .disposed(by: disposeBag)
        
        input.sortTypeButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                output.showAlignmentView.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.newestButtonTapped
            .flatMapLatest {
                self.lastMemoId = StringLiterals.Alignment.newest.lastId
                self.sortType = StringLiterals.Alignment.newest.sortType
                return self.getDataFromAPI(id: self.lastMemoId, sortType: self.sortType)
            }
            .subscribe(with: self, onNext: { owner, memo in
                output.recordMemoCount.accept(memo.memoCount)
                output.recordMemoList.accept(memo.memos)
                output.alignNewest.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.oldestButtonTapped
            .flatMapLatest {
                self.lastMemoId = StringLiterals.Alignment.oldest.lastId
                self.sortType = StringLiterals.Alignment.oldest.sortType
                return self.getDataFromAPI(id: self.lastMemoId, sortType: self.sortType)
            }
            .subscribe(with: self, onNext: { owner, memo in
                output.recordMemoCount.accept(memo.memoCount)
                output.recordMemoList.accept(memo.memos)
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
