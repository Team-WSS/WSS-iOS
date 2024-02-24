//
//  MemoEditViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import RxKeyboard

final class MemoEditViewController: UIViewController {
    
    //MARK: - Properties
    
    private let repository: MemoRepository
    private let disposeBag = DisposeBag()
    private let userNovelId: Int?
    private let memoId: Int?
    private var memoContent: String?
    private var updatedMemoContent = ""
    private let memoContentPredicate = NSPredicate(format: "SELF MATCHES %@", "^[\\s]+$")
    private let maximumMemoContentCount: Int = 2000

    //MARK: - Components

    private let rootView = MemoEditView()
    private let backButton = UIButton()
    private let completeButton = UIButton()

    //MARK: - Life Cycle
    
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
         
         setUI()
         setNavigationBar()
         setNotificationCenter()
         bindUI()
         bindAction()
         bindNavigation()
         
         rootView.memoEditContentView.memoTextView.becomeFirstResponder()
     }
    
    //MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        completeButton.do {
            $0.setButtonAttributedTitle(text: StringLiterals.Memo.complete, font: .Title2, color: .wssPrimary100)
            $0.isEnabled = false
        }
    }
    
    private func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.completeButton)
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.canceledEdit(_:)),
            name: NSNotification.Name("CanceledEdit"),
            object: nil
        )
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        view.addGestureRecognizer(tapGesture)
    }

    //MARK: - Bind
    
        
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    private func bindUI() {
        rootView.memoEditContentView.memoTextView.rx.text.orEmpty
            .subscribe(with: self, onNext: { owner, text in
                owner.updatedMemoContent = text
                owner.rootView.memoEditContentView.memoTextView.text = String(text.prefix(owner.maximumMemoContentCount))

                let isEmpty = text.count == 0
                let isOverLimit = text.count > owner.maximumMemoContentCount
                let isWrongFormat = owner.memoContentPredicate.evaluate(with: owner.updatedMemoContent)
                let isNotChanged = owner.updatedMemoContent == owner.memoContent

                if isEmpty || isOverLimit || isWrongFormat || isNotChanged {
                     owner.disableCompleteButton()
                } else {
                    owner.enableCompleteButton()
                }
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(with: self, onNext: { owner, keyboardHeight in
                owner.rootView.memoEditContentView.updateTextViewConstraint(keyboardHeight: keyboardHeight)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func bindAction() {
        completeButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                if owner.memoContent != nil {
                    owner.patchMemo()
                } else {
                    owner.postMemo()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNavigation() {
        backButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                if owner.memoContent != nil {
                    if owner.updatedMemoContent != owner.memoContent {
                        owner.presentMemoEditCancelViewController()
                    } else {
                        owner.popToLastViewController()
                    }
                } else {
                    if owner.updatedMemoContent.count > 0 && !owner.memoContentPredicate.evaluate(with: owner.updatedMemoContent) {
                        owner.presentMemoEditCancelViewController()
                    } else {
                        owner.popToLastViewController()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - API
    
    private func postMemo() {
        repository.postMemo(userNovelId: self.userNovelId!, memoContent: updatedMemoContent)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                if data.isAvatarUnlocked {
                    NotificationCenter.default.post(name: NSNotification.Name("AvatarUnlocked"), object: nil)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name("PostedMemo"), object: nil)
                }
                owner.popToLastViewController()
            },onError: { owner, error in
                print(error)
                owner.showToast(.memoSaveFail)
            })
            .disposed(by: disposeBag)
    }
    
    private func patchMemo() {
        repository.patchMemo(memoId: self.memoId!, memoContent: updatedMemoContent)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                NotificationCenter.default.post(name: NSNotification.Name("PatchedMemo"), object: nil)
                owner.popToLastViewController()
            },onError: { owner, error in
                print(error)
                owner.showToast(.memoSaveFail)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    func enableCompleteButton() {
        completeButton.do {
            $0.setButtonAttributedTitle(text: StringLiterals.Memo.complete, font: .Title2, color: .wssPrimary100)
            $0.isEnabled = true
        }
    }
    
    func disableCompleteButton() {
        completeButton.do {
            $0.setButtonAttributedTitle(text: StringLiterals.Memo.complete, font: .Title2, color: .wssGray200)
            $0.isEnabled = false
        }
    }
    
    @objc func canceledEdit(_ notification: Notification) {
        self.popToLastViewController()
    }
}
