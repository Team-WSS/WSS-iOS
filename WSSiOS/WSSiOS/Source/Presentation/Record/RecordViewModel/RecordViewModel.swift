//
//  RecordViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 2/19/24.
//

import Foundation

import RxSwift
import RxCocoa

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output
}

final class RecordViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let memoRepository: DefaultMemoRepository
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let sortTypeButtonTapped: Driver<Void>
        let newestButtonTapped: Driver<Void>
        let oldestButtonTapped: Driver<Void>
        let cellTapped: Driver<IndexPath>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let recordMomoCount: BehaviorRelay<Int>
        let recordItem: BehaviorRelay<[RecordTableViewCell]>
    }
    
    //MARK: - init
    
    init(memoRepository: DefaultMemoRepository) {
        self.memoRepository = memoRepository
    }
}

//MARK: - Methods

extension RecordViewModel {
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        input.sortTypeButtonTapped
            .drive(with: self, onNext: { owner, _ in
                
            })
            .disposed(by: disposeBag)
    }
}
