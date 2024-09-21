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
    private var startDate: Date
    private var endDate: Date
    
    //MARK: - Life Cycle
    
    init(readStatus: ReadStatus) {
        self.readStatus = readStatus
        
        self.startDate = Date()
        self.endDate = Date()
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let closeButtonDidTap: ControlEvent<Void>
        let startDateButonDidTap: ControlEvent<Void>
        let endDateButonDidTap: ControlEvent<Void>
        let datePickerDateDidChanged: ControlEvent<Date>
    }
    
    struct Output {
        let dismissModalViewController = PublishRelay<Void>()
        let readStatusData = PublishRelay<ReadStatus>()
        let isStartDateEditing = PublishRelay<Bool>()
        let startDateData = PublishRelay<Date>()
        let endDateData = PublishRelay<Date>()
        let setDatePickerDate = PublishRelay<Date>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(with: self, onNext: { owner, _ in
                output.readStatusData.accept(owner.readStatus)
                
                if owner.readStatus == .quit {
                    owner.isStartDateEditing = false
                    output.isStartDateEditing.accept(owner.isStartDateEditing)
                } else {
                    owner.isStartDateEditing = true
                    output.isStartDateEditing.accept(owner.isStartDateEditing)
                }
                
                output.startDateData.accept(owner.startDate)
                output.endDateData.accept(owner.endDate)
            })
            .disposed(by: disposeBag)
        
        input.closeButtonDidTap
            .subscribe(onNext: { _ in
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.startDateButonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.isStartDateEditing = true
                output.isStartDateEditing.accept(owner.isStartDateEditing)
                output.setDatePickerDate.accept(owner.startDate)
            })
            .disposed(by: disposeBag)
        
        input.endDateButonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                owner.isStartDateEditing = false
                output.isStartDateEditing.accept(owner.isStartDateEditing)
                output.setDatePickerDate.accept(owner.endDate)
            })
            .disposed(by: disposeBag)
        
        input.datePickerDateDidChanged
            .subscribe(with: self, onNext: { owner, date in
                if owner.isStartDateEditing {
                    owner.startDate = date
                    output.startDateData.accept(owner.startDate)
                } else {
                    owner.endDate = date
                    output.endDateData.accept(owner.endDate)
                }
                
                print("startDate", owner.startDate)
                print("endDate", owner.endDate)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
