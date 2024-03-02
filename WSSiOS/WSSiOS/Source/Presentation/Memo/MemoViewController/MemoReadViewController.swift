//
//  MemoReadViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import RxSwift
import RxCocoa

final class MemoReadViewController: UIViewController {
    
    //MARK: - Properties
    
    private let memoReadViewModel: MemoReadViewModel
    private let disposeBag = DisposeBag()
    
    private let viewWillAppearEvent = BehaviorRelay<Int>(value: 0)
    private let memoDetail = PublishRelay<MemoDetail>()
    private let memoId: Int

    //MARK: - Components
    
    private let rootView = MemoReadView()
    private let backButton = UIButton()
    private let editButon = UIButton()

     //MARK: - Life Cycle
    
    init(viewModel: MemoReadViewModel, memoId: Int) {
        self.memoReadViewModel = viewModel
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
        
        viewWillAppearEvent.accept(self.memoId)
    }

     override func viewDidLoad() {
         super.viewDidLoad()
         
         hideTabBar()
         setUI()
         setNavigationBar()
         setNotificationCenter()
         bindViewModel()
         bindNavigation()
     }
    
    //MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        editButon.do {
            $0.setButtonAttributedTitle(text: StringLiterals.Memo.edit, font: .Title2, color: .wssPrimary100)
        }
    }
    
    private func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.editButon)
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
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
    
    //MARK: - Bind
    
    private func bindViewModel() {
        let input = MemoReadViewModel.Input(
            viewWillAppear: viewWillAppearEvent.asObservable()
        )
        
        let output = self.memoReadViewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.memoDetail
            .subscribe(with: self, onNext: { owner, data in
                owner.bindData(data)
            })
            .disposed(by: disposeBag)
    }

    private func bindData(_ memoDetail: MemoDetail) {
        self.memoDetail.accept(memoDetail)
        
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
    
    //MARK: - Actions
    
    private func bindNavigation() {
        backButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.popToLastViewController()
            })
            .disposed(by: disposeBag)
        
        editButon.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(memoDetail)
            .bind(with: self, onNext: { owner, memoDetail in
                owner.pushToMemoEditViewController(
                    memoId: owner.memoId,
                    novelTitle: memoDetail.userNovelTitle,
                    novelAuthor: memoDetail.userNovelAuthor,
                    novelImage: memoDetail.userNovelImg,
                    memoContent: memoDetail.memoContent
                )
            })
            .disposed(by: disposeBag)
        
        rootView.memoReadContentView.deleteButton.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.presentMemoDeleteViewController(memoId: owner.memoId)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Custom Method
    
    @objc func deletedMemo(_ notification: Notification) {
        self.popToLastViewController()
    }
    
    @objc func patchedMemo(_ notification: Notification) {
        showToast(.memoEditSuccess)
    }
}
