//
//  DetailSearchViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import Foundation

import RxSwift
import RxCocoa

final class DetailSearchViewModel: ViewModelType {

    struct Input {
        let cancelButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let cancelButtonEnabled = PublishRelay<Bool>()
    }
}

extension DetailSearchViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.cancelButtonDidTap
            .subscribe(onNext: { _ in
                output.cancelButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
