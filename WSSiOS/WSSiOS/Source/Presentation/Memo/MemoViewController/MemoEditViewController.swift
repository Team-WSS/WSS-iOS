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
    
    private let memoEditViewModel: MemoEditViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components

    private let rootView = MemoEditView()
    private let backButton = UIButton()
    private let completeButton = UIButton()

    //MARK: - Life Cycle
    
    init(viewModel: MemoEditViewModel, novelTitle: String, novelAuthor: String, novelImage: String) {
        self.memoEditViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.rootView.memoHeaderView.bindData(
            novelTitle: novelTitle,
            novelAuthor: novelAuthor,
            novelImage: novelImage
        )
        if let memoContent = viewModel.memoContent {
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
         bindViewModel()
         
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

    //MARK: - Bind
    
    private func bindViewModel() {
        let input = MemoEditViewModel.Input(
            updatedMemoContent: rootView.memoEditContentView.memoTextView.rx.text.orEmpty.asObservable(),
            completeButtonDidTapEvent: completeButton.rx.tap.throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance).asObservable(),
            backButtonDidTapEvent: backButton.rx.tap.throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance).asObservable()
        )
        
        let output = self.memoEditViewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.memoContentPrefix
            .subscribe(with: self, onNext: { owner, memoContentPrefix in
                owner.rootView.memoEditContentView.memoTextView.text = memoContentPrefix
            })
            .disposed(by: disposeBag)
        
        output.completeButtonIsAbled
            .subscribe(with: self, onNext: { owner, isAbled in
                owner.enableCompleteButton(isAbled: isAbled)
            })
            .disposed(by: disposeBag)
        
        output.isMemoSaveSuccess
            .subscribe(with: self, onNext: { owner, isSuccess in
                if isSuccess {
                    owner.popToLastViewController()
                } else {
                    owner.showToast(.memoSaveFail)
                }
            })
            .disposed(by: disposeBag)
        
        output.isFixes
            .subscribe(with: self, onNext: { owner, isFixes in
                if isFixes {
                    owner.presentMemoEditCancelViewController()
                } else {
                    owner.popToLastViewController()
                }
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(with: self, onNext: { owner, keyboardHeight in
                owner.rootView.memoEditContentView.updateTextViewConstraint(keyboardHeight: keyboardHeight)
            })
            .disposed(by: disposeBag)
        
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    func enableCompleteButton(isAbled: Bool) {
        if isAbled {
            completeButton.do {
                $0.setButtonAttributedTitle(text: StringLiterals.Memo.complete, font: .Title2, color: .wssPrimary100)
                $0.isEnabled = true
            }
        } else {
            completeButton.do {
                $0.setButtonAttributedTitle(text: StringLiterals.Memo.complete, font: .Title2, color: .wssGray200)
                $0.isEnabled = false
            }
        }
    }
    
    @objc func canceledEdit(_ notification: Notification) {
        self.popToLastViewController()
    }
}
