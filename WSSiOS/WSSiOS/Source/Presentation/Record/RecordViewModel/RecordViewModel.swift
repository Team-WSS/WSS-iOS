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
    
    // MARK: - Inputs
    
    struct Input {
        let sortTypeButtonTapped: Observable<Void>
//        let newestButtonTapped: Driver<Void>
//        let oldestButtonTapped: Driver<Void>
//        let cellTapped: Driver<IndexPath>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let showAlignmentView = BehaviorRelay<Bool>(value: false)
//        let recordMomoCount = BehaviorRelay<Int>(value: 0)
//        let recordItem = BehaviorRelay<[RecordTableViewCell]>(value: [])
    }
    
    //MARK: - init
    
    init(memoRepository: DefaultMemoRepository) {
        self.memoRepository = memoRepository
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
        
        return output
    }
}
