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
    
    private var isStartDateEditing: Bool = true
    
    //MARK: - Life Cycle
    
    init(readStatus: ReadStatus) {
        self.readStatus = readStatus
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let closeButtonDidTap: ControlEvent<Void>
        let startDateButonDidTap: ControlEvent<Void>
        let endDateButonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let dismissModalViewController = PublishRelay<Void>()
        let readStatusData = PublishRelay<ReadStatus>()
        let isStartDateEditing = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.readStatusData.accept(owner.readStatus)
                
                if owner.readStatus == .quit {
                    output.isStartDateEditing.accept(false)
                } else {
                    output.isStartDateEditing.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        input.closeButtonDidTap
            .subscribe(onNext: { _ in
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.startDateButonDidTap
            .subscribe(onNext: { _ in
                output.isStartDateEditing.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.endDateButonDidTap
            .subscribe(onNext: { _ in
                output.isStartDateEditing.accept(false)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
