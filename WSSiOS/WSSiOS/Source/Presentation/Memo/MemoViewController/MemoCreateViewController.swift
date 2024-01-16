//
//  MemoCreateViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import RxCocoa
import RxKeyboard
import RxSwift

final class MemoCreateViewController: UIViewController {
    
    //MARK: - set Properties
    
    private let repository: MemoRepository
    private let disposeBag = DisposeBag()
    private let novelId: Int
    private var memoContent = ""

    // MARK: - UI Components

    private let rootView = MemoCreateView()
    private let backButton = UIButton()
    private let completeButton = UIButton()

     // MARK: - Life Cycle
    
    init(repository: MemoRepository, novelId: Int, novelTitle: String, novelAuthor: String, novelImage: String) {
        self.repository = repository
        self.novelId = novelId
        super.init(nibName: nil, bundle: nil)
        
        self.rootView.memoHeaderView.bindData(
            novelTitle: novelTitle,
            novelAuthor: novelAuthor,
            novelImage: novelImage
        )
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
    
    // MARK: - set tap gesture
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - set Binding
    
    private func setBinding() {
        backButton.rx.tap.bind {
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        completeButton.rx.tap.bind {
            self.postMemo()
        }.disposed(by: disposeBag)
        
        rootView.memoCreateContentView.memoTextView.rx.text.orEmpty
            .subscribe(onNext: { text in
                self.memoContent = text
                if text.count == 0 {
                    self.disableCompleteButton()
                } else if text.count > 2000 {
                    self.rootView.memoCreateContentView.memoTextView.text = String(text.prefix(2000))
                    self.disableCompleteButton()
                } else {
                    self.enableCompleteButton()
                }
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardHeight in
                self.rootView.memoCreateContentView.updateTextViewConstraint(keyboardHeight: keyboardHeight)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - API request
    
    private func postMemo() {
        repository.postMemo(userNovelId: self.novelId, memoContent: memoContent)
            .subscribe(with: self, onNext: { owner, data in
                Observable.just(())
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        self.navigationController?.popViewController(animated: true)
                    })
                    .disposed(by: self.disposeBag)
            },onError: { owner, error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
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
}
