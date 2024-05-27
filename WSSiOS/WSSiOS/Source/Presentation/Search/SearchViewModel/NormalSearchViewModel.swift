//
//  NormalSearchViewModel.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NormalSearchViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Inputs
    
    struct Input {
        let backButtonDidTap: ControlEvent<Void>
    }
    
    //MARK: - Outputs
    
    struct Output {
        let backButtonEnabled = PublishRelay<Bool>()
    }
    
    //MARK: - init
    
    
    //MARK: - API
    
}

//MARK: - Methods

extension NormalSearchViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.backButtonDidTap
            .subscribe(onNext: { _ in
                output.backButtonEnabled.accept(true)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
