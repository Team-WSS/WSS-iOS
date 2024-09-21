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
        let viewDidLoadEvent: Observable<Void>
        let closeButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let dismissModalViewController = PublishRelay<Void>()
        let readStatusData = PublishRelay<ReadStatus>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.readStatusData.accept(owner.readStatus)
            })
            .disposed(by: disposeBag)
        
        input.closeButtonDidTap
            .subscribe(onNext: { _ in
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
