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
    private let userNovelRepository: UserNovelRepository?
    private let memoRepository: MemoRepository?
    private var popupStatus: PopupStatus
    private let novelId: Int?
    private let memoId: Int?
    
    // MARK: - UI Components
    
    private var rootView: DeletePopupView
    
    // MARK: - Life Cycle
    
    init(userNovelRepository: UserNovelRepository? = nil, memoRepository: MemoRepository? = nil, popupStatus: PopupStatus, novelId: Int? = nil, memoId: Int? = nil) {
        self.userNovelRepository = userNovelRepository
        self.memoRepository = memoRepository
        self.popupStatus = popupStatus
        self.novelId = novelId
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
        
        setBinding()
    }
    
    // MARK: - set Binding
    
    private func setBinding() {
        rootView.deletePopupContentView.cancelButton.rx.tap.bind {
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        switch self.popupStatus {
        case .memoDelete:
            rootView.deletePopupContentView.deleteButton.rx.tap.bind {
                self.deleteMemo()
            }.disposed(by: disposeBag)
        case .memoEditCancel:
            rootView.deletePopupContentView.deleteButton.rx.tap.bind {
                NotificationCenter.default.post(name: NSNotification.Name("CanceledEdit"), object: nil)
                self.dismiss(animated: true)
            }.disposed(by: disposeBag)
        case .novelDelete:
            rootView.deletePopupContentView.deleteButton.rx.tap.bind {
                self.deleteUserNovel()
            }.disposed(by: disposeBag)
        }
    }
    
    // MARK: - API request
    
    private func deleteUserNovel() {
        userNovelRepository!.deleteUserNovel(userNovelId: self.novelId!)
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
