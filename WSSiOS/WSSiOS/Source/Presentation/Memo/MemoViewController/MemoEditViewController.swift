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
    private let novelId: Int
    private let memoId: Int
    private var novelTitle = ""
    private var novelAuthor = ""
    private var novelImage = ""
    private var memoContent = ""

    // MARK: - UI Components

    private let rootView = MemoEditView()
    private let backButton = UIButton()
    private let editButon = UIButton()

     // MARK: - Life Cycle
    
    init(repository: MemoRepository, novelId: Int, memoId: Int) {
        self.repository = repository
        self.novelId = novelId
        self.memoId = memoId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     override func loadView() {
         self.view = rootView
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMemoDetail()
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.editButon)
    }
    
    // MARK: - set UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(ImageLiterals.icon.navigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        editButon.do {
            $0.setButtonAttributedTitle(text: "수정", font: .Title2, color: .Primary100)
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
        
        editButon.rx.tap.bind {
            self.navigationController?.pushViewController(MemoCreateViewController(
                repository: DefaultMemoRepository(
                    memoService: DefaultMemoService()),
                novelId: self.novelId,
                novelTitle: self.novelTitle,
                novelAuthor: self.novelAuthor,
                novelImage: self.novelImage
            ), animated: true)
        }.disposed(by: disposeBag)
        
        rootView.memoEditContentView.memoTextView.rx.text.orEmpty
            .subscribe(onNext: { text in
                self.memoContent = text
                if text.count > 2000 {
                    self.rootView.memoEditContentView.memoTextView.text = String(text.prefix(2000))
                }
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardHeight in
                self.rootView.memoEditContentView.updateTextViewConstraint(keyboardHeight: keyboardHeight)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - update UI
    
    private func updateUI(_ memoDetail: MemoDetail) {
        self.novelTitle = memoDetail.userNovelTitle
        self.novelAuthor = memoDetail.userNovelAuthor
        self.novelImage = memoDetail.userNovelImg
        
        Observable.just(())
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.rootView.memoHeaderView.bindData(
                    novelTitle: memoDetail.userNovelTitle,
                    novelAuthor: memoDetail.userNovelAuthor,
                    novelImage: memoDetail.userNovelImg
                )
                
                self.rootView.memoEditContentView.bindData(
                    date: memoDetail.memoDate,
                    memoContent: memoDetail.memoContent
                )
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - API request
    
    private func getMemoDetail() {
        repository.getMemoDetail(memoId: self.memoId)
            .subscribe(with: self, onNext: { owner, data in
                self.updateUI(data)
            },onError: { owner, error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    @objc func viewDidTap() {
        view.endEditing(true)
    }
}
