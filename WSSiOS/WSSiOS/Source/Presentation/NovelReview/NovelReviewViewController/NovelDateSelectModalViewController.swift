//
//  NovelDateSelectModalViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/21/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class NovelDateSelectModalViewController: UIViewController {
    
    //MARK: - Properties
    
    private let novelDateSelectModalViewModel: NovelDateSelectModalViewModel
    private let disposeBag = DisposeBag()
    
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = StringLiterals.Register.Normal.DatePicker.dateFormat
        $0.timeZone = TimeZone(identifier: StringLiterals.Register.Normal.DatePicker.KoreaTimeZone)
    }
    
    //MARK: - Components
    
    private let rootView = NovelDateSelectModalView()
    
    //MARK: - Life Cycle
    
    init(viewModel: NovelDateSelectModalViewModel) {
        self.novelDateSelectModalViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
        viewDidLoadEvent.accept(())
    }
    
    //MARK: - UI
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = NovelDateSelectModalViewModel.Input(
            viewDidLoadEvent: viewDidLoadEvent.asObservable(),
            closeButtonDidTap: rootView.closeButton.rx.tap,
            startDateButonDidTap: rootView.novelDateSelectModalDateButtonView.startDateButton.rx.tap,
            endDateButonDidTap: rootView.novelDateSelectModalDateButtonView.endDateButton.rx.tap,
            datePickerDateDidChanged: rootView.novelDateSelectModalDatePickerView.datePicker.rx.date.changed
        )
        
        let output = self.novelDateSelectModalViewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.dismissModalViewController
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismissModalViewController()
            })
            .disposed(by: disposeBag)
        
        output.readStatusData
            .subscribe(with: self, onNext: { owner, readStatus in
                owner.rootView.bindData(readStatus: readStatus)
            })
            .disposed(by: disposeBag)
        
        output.isStartDateEditing
            .subscribe(with: self, onNext: { owner, isStartDateEditing in
                owner.rootView.novelDateSelectModalDateButtonView.updateDateButtonStyle(isStartDateSelected: isStartDateEditing)
            })
            .disposed(by: disposeBag)
        
        output.startDateData
            .subscribe(with: self, onNext: { owner, startDateData in
                owner.rootView.novelDateSelectModalDateButtonView.updateStartDate(startDate: owner.dateFormatter.string(from: startDateData))
            })
            .disposed(by: disposeBag)
        
        output.endDateData
            .subscribe(with: self, onNext: { owner, endDateData in
                owner.rootView.novelDateSelectModalDateButtonView.updateEndDate(endDate: owner.dateFormatter.string(from: endDateData))
            })
            .disposed(by: disposeBag)
        
        output.setDatePickerDate
            .subscribe(with: self, onNext: { owner, date in
                owner.rootView.novelDateSelectModalDatePickerView.bindData(date: date)
            })
            .disposed(by: disposeBag)
    }
}
