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
    
    
    // MARK: - Inputs
    
    struct Input {
        let sortTypeButtonTapped: Observable<Void>
        let newestButtonTapped: Observable<Void>
        let oldestButtonTapped: Observable<Void>
        let recordCellSelected: Observable<IndexPath>
        let recordMemoCount: Observable<Int>
        let emptyButtonTapped: Observable<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let showAlignmentView = BehaviorRelay<Bool>(value: false)
        let alignNewest = BehaviorRelay<Bool>(value: false)
        let alignOldest = BehaviorRelay<Bool>(value: false)
        let navigateToMemoRead = PublishRelay<IndexPath>()
        let recordMemoCount = BehaviorRelay<Int>(value: 0)
        let navigateEmptyView = BehaviorRelay<Bool>(value: false)
    }
    
    //MARK: - init

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
                output.alignNewest.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.oldestButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                output.alignOldest.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.recordCellSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                output.navigateToMemoRead.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        input.recordMemoCount
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self, onNext: { owner, count in
                output.recordMemoCount.accept(count)
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
