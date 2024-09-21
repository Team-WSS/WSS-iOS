//
//  NovelDateSelectModalViewModel.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/21/24.
//

import Foundation

import RxSwift
import RxCocoa

final class NovelDateSelectModalViewModel: ViewModelType {
    
    //MARK: - Properties
    
    private var readStatus: ReadStatus
    
    //MARK: - Life Cycle
    
    init(readStatus: ReadStatus) {
        self.readStatus = readStatus
    }
    
    struct Input {
        let closeButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let dismissModalViewController = PublishRelay<Void>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.closeButtonDidTap
            .subscribe(onNext: { _ in
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
