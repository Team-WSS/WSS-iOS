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

    private let disposeBag = DisposeBag()
    private let userNovelRepository: UserNovelRepository?
    private let memoRepository: MemoRepository?
    private var popupStatus: PopupStatus
    private let userNovelId: Int?
    private let memoId: Int?
    
    //MARK: - Components
    
    private var rootView: DeletePopupView
    
    //MARK: - Life Cycle
    
    init(userNovelRepository: UserNovelRepository? = nil, memoRepository: MemoRepository? = nil, popupStatus: PopupStatus, userNovelId: Int? = nil, memoId: Int? = nil) {
        self.userNovelRepository = userNovelRepository
        self.memoRepository = memoRepository
        self.popupStatus = popupStatus
        self.userNovelId = userNovelId
        self.memoId = memoId
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
        
        bindAction()
    }
    
    //MARK: - Actions
    
    private func bindAction() {
        rootView.deletePopupContentView.cancelButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.deletePopupContentView.deleteButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                switch owner.popupStatus {
                case .memoEditCancel:
                    NotificationCenter.default.post(name: NSNotification.Name("CanceledEdit"), object: nil)
                    owner.dismiss(animated: true)
                case .memoDelete:
                    owner.deleteMemo()
                case .novelDelete:
                    owner.deleteUserNovel()
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - API
    
    private func deleteUserNovel() {
        if let userNovelRepository = userNovelRepository, let userNovelId = self.userNovelId {
            userNovelRepository.deleteUserNovel(userNovelId: userNovelId)
                .observe(on: MainScheduler.instance)
                .subscribe(with: self, onNext: { owner, data in
                    NotificationCenter.default.post(name: NSNotification.Name("DeletedNovel"), object: nil)
                    owner.dismiss(animated: true)
                },onError: { owner, error in
                    print(error)
                }).disposed(by: disposeBag)
        }
    }
    
    private func deleteMemo() {
        if let memoRepository = memoRepository, let memoId = self.memoId {
            memoRepository.deleteMemo(memoId: memoId)
                .observe(on: MainScheduler.instance)
                .subscribe(with: self, onNext: { owner, data in
                    NotificationCenter.default.post(name: NSNotification.Name("DeletedMemo"), object: nil)
                    owner.dismiss(animated: true)
                },onError: { owner, error in
                    print(error)
                }).disposed(by: disposeBag)
        }
    }
}
