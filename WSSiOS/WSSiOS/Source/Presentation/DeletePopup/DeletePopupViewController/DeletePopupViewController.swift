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

    //MARK: - set Properties

    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private var rootView: DeletePopupView?
    
    // MARK: - Life Cycle
    
    init(_ popupStatus: PopupStatus) {
        super.init(nibName: nil, bundle: nil)

        rootView = DeletePopupView(popupStatus)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    // MARK: - bind
    
    private func bind() {
        rootView?.deletePopupContentView?.cancelButton.rx.tap.bind {
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
