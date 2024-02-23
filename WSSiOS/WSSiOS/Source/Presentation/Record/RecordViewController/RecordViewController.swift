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
    
    private let recordViewModel: RecordViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let rootView = RecordResultView()
    private let emptyView = RecordEmptyView()
    
    //MARK: - Life Cycle
    
    init(recordViewModel: RecordViewModel) {
        self.recordViewModel = recordViewModel
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
        
        recordViewModel.getDataFromAPI(
            id: recordViewModel.lastMemoId,
            sortType: recordViewModel.alignmentLabel)
        
        showTabBar()
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.record,
                                    left: nil,
                                    right: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        register()
        
        bindViewModel()
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
    }
    
    //MARK: - Notification Center
    
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

extension RecordViewController {
    
    private func bindViewModel() {
        recordViewModel.recordMemoList
            .bind(to: rootView.recordTableView.rx.items(
                cellIdentifier: RecordTableViewCell.cellIdentifier,
                cellType: RecordTableViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        recordViewModel.recordMemoCount
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
        
        let input = RecordViewModel.Input(
            sortTypeButtonTapped: self.rootView.headerView.headerAlignmentButton
                .rx.tap.asObservable(),
            newestButtonTapped: self.rootView.alignmentView.libraryNewestButton
                .rx.tap.asObservable(),
            oldestButtonTapped: self.rootView.alignmentView.libraryOldesttButton
                .rx.tap.asObservable(),
            recordCellSelected: self.rootView.recordTableView
                .rx.itemSelected.asObservable(),
            emptyButtonTapped: self.emptyView.recordButton
                .rx.tap.asObservable()
        )
        
        let output = self.recordViewModel.transform(from: input, disposeBag: disposeBag)
        
        output.showAlignmentView
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.alignmentView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
        
        output.alignNewest
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.headerView.headerAlignmentButton.setTitle(StringLiterals.Alignment.newest.title, for: .normal)
                owner.rootView.alignmentView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        output.alignOldest
            .bind(with: self, onNext: { owner, _ in
                owner.rootView.headerView.headerAlignmentButton.setTitle(StringLiterals.Alignment.oldest.title, for: .normal)
                owner.rootView.alignmentView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        output.navigateToMemoRead
            .bind(with: self, onNext: { owner, indexPath in
                owner.pushToMemoReadViewController(memoId: owner.recordViewModel.recordMemoList.value[indexPath.row].id)
            })
            .disposed(by: disposeBag)
        
        output.navigateEmptyView
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.tabBarController?.selectedIndex = 1
            })
            .disposed(by: disposeBag)
    }
}
