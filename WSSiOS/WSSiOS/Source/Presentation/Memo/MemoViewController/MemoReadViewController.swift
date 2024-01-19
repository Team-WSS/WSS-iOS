//
//  MemoReadViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import RxCocoa
import RxSwift

final class MemoReadViewController: UIViewController {
    
    //MARK: - set Properties
    
    private let repository: MemoRepository
    private let disposeBag = DisposeBag()
    private let memoId: Int
    private var novelTitle = ""
    private var novelAuthor = ""
    private var novelImage = ""
    private var memoContent = ""

    // MARK: - UI Components

    private let rootView = MemoReadView()
    private let backButton = UIButton()
    private let editButon = UIButton()

     // MARK: - Life Cycle
    
    init(repository: MemoRepository, memoId: Int) {
        self.repository = repository
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
         setNotificationCenter()
         setTapGesture()
         setBinding()
     }
    
    // MARK: - set NavigationBar
    
    private func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.editButon)
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    // MARK: - set UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(ImageLiterals.icon.navigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        editButon.do {
            $0.setButtonAttributedTitle(text: "수정", font: .Title2, color: .Primary100)
        }
    }
    
    // MARK: - setNotificationCenter

    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.deletedMemo(_:)),
            name: NSNotification.Name("DeletedMemo"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.patchedMemo(_:)),
            name: NSNotification.Name("PatchedMemo"),
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
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        editButon.rx.tap.bind {
            self.navigationController?.pushViewController(MemoEditViewController(
                repository: DefaultMemoRepository(
                    memoService: DefaultMemoService()
                ),
                memoId: self.memoId,
                novelTitle: self.novelTitle,
                novelAuthor: self.novelAuthor,
                novelImage: self.novelImage,
                memoContent: self.memoContent
            ), animated: true)
        }.disposed(by: disposeBag)
        
        rootView.memoReadContentView.deleteButton.rx.tap.bind {
            let vc = DeletePopupViewController(
                memoRepository: DefaultMemoRepository(
                    memoService: DefaultMemoService()
                ),
                popupStatus: .memoDelete,
                memoId: self.memoId
            )
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    
    // MARK: - update UI
    
    private func updateUI(_ memoDetail: MemoDetail) {
        self.novelTitle = memoDetail.userNovelTitle
        self.novelAuthor = memoDetail.userNovelAuthor
        self.novelImage = memoDetail.userNovelImg
        self.memoContent = memoDetail.memoContent
        
        self.rootView.memoHeaderView.bindData(
            novelTitle: memoDetail.userNovelTitle,
            novelAuthor: memoDetail.userNovelAuthor,
            novelImage: memoDetail.userNovelImg
        )
        
        self.rootView.memoReadContentView.bindData(
            date: memoDetail.memoDate,
            memoContent: memoDetail.memoContent
        )
    }
    
    // MARK: - API request
    
    private func getMemoDetail() {
        repository.getMemoDetail(memoId: self.memoId)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, data in
                self.updateUI(data)
            },onError: { owner, error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - custom method
    
    @objc func viewDidTap() {
        view.endEditing(true)
    }
    
    @objc func deletedMemo(_ notification: Notification) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func patchedMemo(_ notification: Notification) {
        showToast(.memoEditSuccess)
    }
}
