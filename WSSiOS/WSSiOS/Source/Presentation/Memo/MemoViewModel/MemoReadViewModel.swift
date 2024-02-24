//
//  MemoReadViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 2/24/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MemoReadViewModel: ViewModelType {
    
    //MARK: - Properties
        
    private let memoRepository: MemoRepository
       
    //MARK: - Life Cycle
    
    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Int>
    }
    
    struct Output {
        let memoDetail = PublishRelay<MemoDetail>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .flatMapLatest { memoId in
                self.getMemoDetail(memoId: memoId)
            }
            .subscribe(with: self, onNext: { owner, data in
                output.memoDetail.accept(data)
            }, onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func getMemoDetail(memoId: Int) -> Observable<MemoDetail> {
        memoRepository.getMemoDetail(memoId: memoId)
            .observe(on: MainScheduler.instance)
    }
}
