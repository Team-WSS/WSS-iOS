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
    
    init(readStatus: ReadStatus, startDate: Date?, endDate: Date?) {
        self.readStatus = readStatus
        
        self.startDate = startDate ?? Date()
        self.endDate = endDate ?? Date()
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let closeButtonDidTap: ControlEvent<Void>
        let startDateButonDidTap: ControlEvent<Void>
        let endDateButonDidTap: ControlEvent<Void>
        let datePickerDateDidChanged: ControlEvent<Date>
        let completeButtonDidTap: ControlEvent<Void>
        let removeButtonDidTap: ControlEvent<Void>
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
                
                if owner.isStartDateEditing {
                    output.setDatePickerDate.accept(owner.startDate)
                } else {
                    output.setDatePickerDate.accept(owner.endDate)
                }
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
                let today = Date()
                let isFutureDate = date > today
                
                if owner.isStartDateEditing {
                    if isFutureDate { // 미래의 날짜일 경우
                        output.setDatePickerDate.accept(owner.startDate)
                    } else {
                        owner.startDate = date
                        output.startDateData.accept(owner.startDate)
                        
                        // 시작날짜가 종료날짜보다 미래일 경우, 종료날짜를 시작날짜와 동일하게 설정
                        if owner.startDate > owner.endDate {
                            owner.endDate = owner.startDate
                            output.endDateData.accept(owner.endDate)
                        }
                    }
                } else {
                    if isFutureDate { // 미래의 날짜일 경우
                        output.setDatePickerDate.accept(owner.endDate)
                    } else if owner.startDate > date { // 종료날짜가 시작날짜보다 과거일 경우
                        if owner.readStatus == .quit { // 읽기 상태가 '하차'일 경우
                            owner.endDate = date
                            output.endDateData.accept(owner.endDate)
                            
                            // 시작날짜를 종료날짜와 동일하게 설정
                            owner.startDate = owner.endDate
                            output.startDateData.accept(owner.startDate)
                        } else { // 읽기 상태가 '봤어요'일 경우
                            output.setDatePickerDate.accept(owner.endDate)
                        }
                    } else {
                        owner.endDate = date
                        output.endDateData.accept(owner.endDate)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        input.completeButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: NSNotification.Name("NovelReviewDateSelected"), object: [owner.startDate, owner.endDate])
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        input.removeButtonDidTap
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: NSNotification.Name("NovelReviewDateRemoved"), object: nil)
                output.dismissModalViewController.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
