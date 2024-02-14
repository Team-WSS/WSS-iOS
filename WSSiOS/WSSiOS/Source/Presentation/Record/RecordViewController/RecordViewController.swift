//
//  RecordViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

import RxSwift
import RxCocoa
import Then

final class RecordViewController: UIViewController {
    
    //MARK: - Properties
    
    private let memoRepository: DefaultMemoRepository
    private var recordMemoListRelay = BehaviorRelay<[RecordMemo]>(value: [])
    private var recordMemoCount = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    private var lastMemoId = StringLiterals.Alignment.newest.lastNovelId
    private var alignmentLabel = StringLiterals.Alignment.newest.sortType
    
    //MARK: - Components
    
    private let rootView = RecordResultView()
    private let emptyView = RecordEmptyView()
    
    //MARK: - Life Cycle
    
    init(memoRepository: DefaultMemoRepository) {
        self.memoRepository = memoRepository
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
        
        getDataFromAPI(id: lastMemoId, sortType: alignmentLabel)
        
        showTabBar()
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.record,
                                    left: nil,
                                    right: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        register()
        
        bindUI()
        setNotificationCenter()
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
        rootView.headerView.isUserInteractionEnabled = true
    }
    
    //MARK: - Bind
    
    private func register() {
        rootView.recordTableView.register(
            RecordTableViewCell.self,
            forCellReuseIdentifier: RecordTableViewCell.cellIdentifier)
        
        recordMemoListRelay
            .bind(to: rootView.recordTableView.rx.items(cellIdentifier: RecordTableViewCell.cellIdentifier, cellType: RecordTableViewCell.self)) { (row, element, cell) in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        rootView.headerView.headerAlignmentButton
            .rx.tap
            .bind(with: self, onNext: { owner, event in
                owner.rootView.alignmentView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
             
        rootView.alignmentView.libraryNewestButton
            .rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.lastMemoId = StringLiterals.Alignment.newest.lastNovelId
                owner.alignmentLabel = StringLiterals.Alignment.newest.sortType
                owner.rootView.headerView.headerAlignmentButton.setTitle(StringLiterals.Alignment.newest.title, for: .normal)
                owner.getDataFromAPI(id: owner.lastMemoId, sortType: owner.alignmentLabel)
                owner.rootView.alignmentView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        rootView.alignmentView.libraryOldesttButton
            .rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.lastMemoId = StringLiterals.Alignment.oldest.lastNovelId
                owner.alignmentLabel = StringLiterals.Alignment.oldest.sortType
                owner.rootView.headerView.headerAlignmentButton.setTitle(StringLiterals.Alignment.oldest.title, for: .normal)
                owner.getDataFromAPI(id: owner.lastMemoId, sortType: owner.alignmentLabel)
                owner.rootView.alignmentView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        recordMemoCount
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.rootView.headerView.recordCountLabel.text = "\(value)개"
                if value == 0 {
                    owner.rootView.addSubview(owner.emptyView)
                    owner.emptyView.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                }
                else {
                    owner.emptyView.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
            
        rootView.recordTableView
            .rx
            .itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.navigationController?.pushViewController(MemoReadViewController(repository: DefaultMemoRepository(memoService: DefaultMemoService()), memoId: owner.recordMemoListRelay.value[indexPath.row].id), animated: true)
            })
            .disposed(by: disposeBag)
        
        emptyView.recordButton
            .rx.tap
            .subscribe(with: self, onNext: { owner, event in
                owner.navigationController?.tabBarController?.selectedIndex = 1
            })
            .disposed(by: self.disposeBag)
    }

    //MARK: - API
    
    func getDataFromAPI(id: Int,
                        sortType: String) {
        self.memoRepository.getRecordMemoList(memoId: id, sort: sortType)
            .subscribe(with: self, onNext: { owner, memo in
                owner.recordMemoCount.accept(memo.memoCount)
                owner.recordMemoListRelay.accept(memo.memos)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.deletedMemo(_:)),
            name: NSNotification.Name("DeletedMemo"),
            object: nil
        )
    }
    
    @objc func deletedMemo(_ notification: Notification) {
        showToast(.memoDelete)
    }
}
