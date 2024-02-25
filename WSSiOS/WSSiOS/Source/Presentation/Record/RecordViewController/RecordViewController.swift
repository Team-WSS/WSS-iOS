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
    private let viewWillAppearEvent = PublishSubject<Void>()
    
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
    
        showTabBar()
        preparationSetNavigationBar(title: StringLiterals.Navigation.Title.record,
                                    left: nil,
                                    right: nil)
        viewWillAppearEvent.onNext(())
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
        let input = RecordViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent.asObservable(),
            sortTypeButtonTapped: rootView.headerView.headerAlignmentButton.rx.tap,
            newestButtonTapped: rootView.alignmentView.libraryNewestButton.rx.tap,
            oldestButtonTapped: rootView.alignmentView.libraryOldesttButton.rx.tap,
            recordCellSelected: rootView.recordTableView.rx.itemSelected,
            emptyButtonTapped: emptyView.recordButton.rx.tap
        )
        
        let output = recordViewModel.transform(from: input, disposeBag: disposeBag)
        
        output.recordMemoList
            .bind(to: rootView.recordTableView.rx.items(
                cellIdentifier: RecordTableViewCell.cellIdentifier,
                cellType: RecordTableViewCell.self)) { row, element, cell in
                    cell.bindData(data: element)
                }
                .disposed(by: disposeBag)
        
        output.recordMemoCount
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
                owner.pushToMemoReadViewController(memoId: output.recordMemoList.value[indexPath.row].id)
            })
            .disposed(by: disposeBag)
        
        output.navigateEmptyView
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.tabBarController?.selectedIndex = 1
            })
            .disposed(by: disposeBag)
    }
}
