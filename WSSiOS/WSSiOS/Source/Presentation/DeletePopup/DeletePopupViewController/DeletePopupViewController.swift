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
        rootView.deletePopupContentView.cancelButton.rx.tap.bind {
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        rootView.deletePopupContentView.deleteButton.rx.tap.bind {
            switch self.popupStatus {
            case .memoDelete:
                self.deleteMemo()
            case .memoEditCancel:
                NotificationCenter.default.post(name: NSNotification.Name("CanceledEdit"), object: nil)
                self.dismiss(animated: true)
            case .novelDelete:
                self.deleteUserNovel()
            }
        }.disposed(by: disposeBag)
    }
    
    //MARK: - API
    
    private func deleteUserNovel() {
        userNovelRepository!.deleteUserNovel(userNovelId: self.userNovelId!)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                NotificationCenter.default.post(name: NSNotification.Name("DeletedNovel"), object: nil)
                self.dismiss(animated: true)
            },onError: { owner, error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    private func deleteMemo() {
        memoRepository!.deleteMemo(memoId: self.memoId!)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                NotificationCenter.default.post(name: NSNotification.Name("DeletedMemo"), object: nil)
                self.dismiss(animated: true)
            },onError: { owner, error in
                print(error)
            }).disposed(by: disposeBag)
    }
}
