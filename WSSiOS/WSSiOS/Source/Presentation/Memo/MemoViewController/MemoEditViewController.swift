//
//  MemoEditViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import RxCocoa
import RxKeyboard
import RxSwift

final class MemoEditViewController: UIViewController {
    
    //MARK: - set Properties
    
    private let repository: MemoRepository
    private let disposeBag = DisposeBag()
    private let userNovelId: Int?
    private let memoId: Int?
    private var memoContent: String?
    private var updatedMemoContent = ""

    // MARK: - UI Components

    private let rootView = MemoEditView()
    private let backButton = UIButton()
    private let completeButton = UIButton()

     // MARK: - Life Cycle
    
    init(repository: MemoRepository, userNovelId: Int? = nil, memoId: Int? = nil, novelTitle: String, novelAuthor: String, novelImage: String, memoContent: String? = nil) {
        self.repository = repository
        self.userNovelId = userNovelId
        self.memoId = memoId
        self.memoContent = memoContent
        super.init(nibName: nil, bundle: nil)
        
        self.rootView.memoHeaderView.bindData(
            novelTitle: novelTitle,
            novelAuthor: novelAuthor,
            novelImage: novelImage
        )
        if let memoContent = memoContent {
            self.updatedMemoContent = memoContent
            self.rootView.memoEditContentView.bindData(
                memoContent: memoContent
            )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     override func loadView() {
         self.view = rootView
     }

     override func viewDidLoad() {
         super.viewDidLoad()
         
         setNavigationBar()
         setUI()
         setNotificationCenter()
         setTapGesture()
         setBinding()
     }
    
    // MARK: - set NavigationBar
    
    private func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.completeButton)
    }
    
    // MARK: - set UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(ImageLiterals.icon.navigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        completeButton.do {
            $0.setButtonAttributedTitle(text: "완료", font: .Title2, color: .Primary100)
            $0.isEnabled = false
        }
    }
    
    // MARK: - setNotificationCenter

    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.canceledEdit(_:)),
            name: NSNotification.Name("CanceledEdit"),
            object: nil
        )
    }
    
    // MARK: - set tap gesture
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - set Binding
    
    private func setBinding() {
        backButton.rx.tap.bind {
            if self.memoContent != nil {
                if self.updatedMemoContent != self.memoContent {
                    let vc = DeletePopupViewController(
                        memoRepository: DefaultMemoRepository(
                            memoService: DefaultMemoService()
                        ),
                        popupStatus: .memoEditCancel
                    )
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                if self.updatedMemoContent.count > 0 {
                    let vc = DeletePopupViewController(
                        memoRepository: DefaultMemoRepository(
                            memoService: DefaultMemoService()
                        ),
                        popupStatus: .memoEditCancel
                    )
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }.disposed(by: disposeBag)
        
        completeButton.rx.tap.bind {
            if self.memoContent != nil {
                self.patchMemo()
            } else {
                self.postMemo()
            }
        }.disposed(by: disposeBag)
        
        rootView.memoEditContentView.memoTextView.rx.text.orEmpty
            .subscribe(onNext: { text in
                self.updatedMemoContent = text
                if text.count == 0 {
                    self.disableCompleteButton()
                } else if text.count > 2000 {
                    self.rootView.memoEditContentView.memoTextView.text = String(text.prefix(2000))
                    self.disableCompleteButton()
                } else {
                    self.enableCompleteButton()
                }
                if self.memoContent != nil {
                    if self.updatedMemoContent == self.memoContent {
                        self.disableCompleteButton()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardHeight in
                self.rootView.memoEditContentView.updateTextViewConstraint(keyboardHeight: keyboardHeight)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - API request
    
    private func postMemo() {
        repository.postMemo(userNovelId: self.userNovelId!, memoContent: updatedMemoContent)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                if data.isAvatarUnlocked {
                    NotificationCenter.default.post(name: NSNotification.Name("AvatarUnlocked"), object: nil)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name("PostedMemo"), object: nil)
                }
                self.navigationController?.popViewController(animated: true)
            },onError: { owner, error in
                print(error)
                self.showToast(.memoSaveFail)
            })
            .disposed(by: disposeBag)
    }
    
    private func patchMemo() {
        repository.patchMemo(memoId: self.memoId!, memoContent: updatedMemoContent)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                NotificationCenter.default.post(name: NSNotification.Name("PatchedMemo"), object: nil)
                self.navigationController?.popViewController(animated: true)
            },onError: { owner, error in
                print(error)
                self.showToast(.memoSaveFail)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - custom method
    
    func enableCompleteButton() {
        completeButton.do {
            $0.setButtonAttributedTitle(text: "완료", font: .Title2, color: .Primary100)
            $0.isEnabled = true
        }
    }
    
    func disableCompleteButton() {
        completeButton.do {
            $0.setButtonAttributedTitle(text: "완료", font: .Title2, color: .Gray200)
            $0.isEnabled = false
        }
    }
    
    @objc func viewDidTap() {
        view.endEditing(true)
    }
    
    @objc func canceledEdit(_ notification: Notification) {
        self.navigationController?.popViewController(animated: true)
    }
}
