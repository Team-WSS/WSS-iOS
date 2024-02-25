//
//  DeletePopupViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/14/24.
//

import UIKit

import RxSwift
import RxCocoa

final class DeletePopupViewController: UIViewController {

    //MARK: - Properties

    private let deletePopupViewModel: DeletePopupViewModel
    private let disposeBag = DisposeBag()
    private var popupStatus: PopupStatus
    
    //MARK: - Components
    
    private var rootView: DeletePopupView
    
    //MARK: - Life Cycle
    
    init(viewModel: DeletePopupViewModel, popupStatus: PopupStatus) {
        self.deletePopupViewModel = viewModel
        self.popupStatus = popupStatus
        rootView = DeletePopupView(self.popupStatus)
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
        bindNavigation()
    }
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = DeletePopupViewModel.Input(
            popupStatus: self.popupStatus,
            deleteButtonDidTapEvent: rootView.deletePopupContentView.deleteButton.rx.tap.throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance).asObservable()
        )

        let output = self.deletePopupViewModel.transform(from: input, disposeBag: self.disposeBag)

        output.canceledEdit
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: NSNotification.Name("CanceledEdit"), object: nil)
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.deletedMemo
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: NSNotification.Name("DeletedMemo"), object: nil)
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.deletedNovel
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(name: NSNotification.Name("DeletedNovel"), object: nil)
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func bindNavigation() {
        rootView.deletePopupContentView.cancelButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
