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
    private let repository: UserNovelRepository
    private var popupStatus: PopupStatus
    private let novelId: Int
    
    // MARK: - UI Components
    
    private var rootView: DeletePopupView
    
    // MARK: - Life Cycle
    
    init(repository: UserNovelRepository, popupStatus: PopupStatus, novelId: Int) {
        self.repository = repository
        self.popupStatus = popupStatus
        self.novelId = novelId
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
        
        bind()
    }
    
    // MARK: - bind
    
    private func bind() {
        rootView.deletePopupContentView.cancelButton.rx.tap.bind {
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        switch self.popupStatus {
        case .memoDelete: break
        case .memoEditCancel: break
        case .novelDelete:
            rootView.deletePopupContentView.deleteButton.rx.tap.bind {
                self.deleteUserNovel()
            }.disposed(by: disposeBag)
        }
    }
    
    // MARK: - API request
    
    private func deleteUserNovel() {
        repository.deleteUserNovel(userNovelId: self.novelId)
            .subscribe(with: self, onNext: { owner, data in
                // 소설 삭제 후 로직
                // self.dismiss(animated: true)
            },onError: { owner, error in
                print(error)
            }).disposed(by: disposeBag)
    }
}
