//
//  RecordViewModel.swift
//  WSSiOS
//
//  Created by 최서연 on 1/15/24.
//

import Foundation

import RxSwift

final class RecordViewModel {
    internal var disposeBag = DisposeBag()
    
    private let memoRepository: DefaultMemoRepository
    
    init(memoRepository: DefaultMemoRepository) {
        self.memoRepository = memoRepository
    }
     
    func transform(disposeBag: DisposeBag) {
        self.memoRepository.getRecordMemoList()
            .subscribe (
                onNext: { memo in
                    print(memo)
                },
                onError: { error in
                    print(error)
                })
            .disposed(by: disposeBag)
    }
}
