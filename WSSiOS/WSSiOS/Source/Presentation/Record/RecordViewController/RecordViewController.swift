//
//  RecordViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxRelay

final class RecordViewController: UIViewController {
    
    //MARK: - Properties
    
    private let memoRepository: DefaultMemoRepository
    var recordMemoCount = 0
    var recordMemoListRelay = BehaviorRelay<[RecordMemo]>(value: [])
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = RecordResultView()
    
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
        
        bindDataToUI()
        
        if let tabBarController = self.tabBarController as? WSSTabBarController {
            tabBarController.tabBar.isHidden = false
            tabBarController.shadowView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        registerCell()
        setAction()
        
        bindDataToRecordTableView()
        setNavigationBar()
    }
    
    private func setUI() {
        self.view.do {
            $0.backgroundColor = .White
        }
        
        rootView.headerView.isUserInteractionEnabled = true
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "내 기록"
        self.navigationController?.navigationBar.backgroundColor = .White
        
        // Navigation Bar의 title 폰트 설정
        if let navigationBar = self.navigationController?.navigationBar {
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.Title2
            ]
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    
    private func registerCell() {
        rootView.recordTableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.identifier)
    }
    
    private func setAction() {
        rootView.headerView.headerAlignmentButton
            .rx.tap
            .bind(with: self, onNext: { owner, event in
                owner.rootView.alignmentView.isHidden.toggle()
            })
            .disposed(by: disposeBag)
    }
    
    func getDataFromAPI(disposeBag: DisposeBag, completion: @escaping (Int, [RecordMemo]) -> Void) {
        self.memoRepository.getRecordMemoList()
            .subscribe (
                onNext: { [weak self] memo in
                    guard self != nil else { return }
                    let recordMemoCount = memo.memoCount
                    let recordMemoList = memo.memos
                    
                    completion(recordMemoCount, recordMemoList)
                },
                onError: { error in
                    print(error)
                })
            .disposed(by: disposeBag)
    }
    
    private func bindDataToRecordTableView() {
        recordMemoListRelay
            .bind(to: rootView.recordTableView.rx.items(cellIdentifier: RecordTableViewCell.identifier, cellType: RecordTableViewCell.self)) { (row, element, cell) in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
        
        rootView.recordTableView
            .rx
            .itemSelected
            .subscribe(onNext:{ indexPath in
                self.navigationController?.pushViewController(MemoReadViewController(repository: DefaultMemoRepository(memoService: DefaultMemoService()), memoId: self.recordMemoListRelay.value[indexPath.row].id) , animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func bindDataToUI() {
        self.getDataFromAPI(disposeBag: disposeBag) { [weak self] recordMemoCount, recordMemoList in
            // 뷰 컨트롤러에서 전달받은 데이터 처리
            self?.updateUI(recordMemoCount: recordMemoCount, recordMemoList: recordMemoList)
        }
    }
    
    // UI 로직 구현
    func updateUI(recordMemoCount: Int, recordMemoList: [RecordMemo]) {
        Observable.combineLatest(
            Observable.just(recordMemoCount),
            Observable.just(recordMemoList)
        )
        .observe(on: MainScheduler.instance)
        .subscribe(with: self, onNext: { owner, event in
            owner.rootView.headerView.recordCountLabel.text = "\(event.0)개"
            if event.0 == 0 {
                let emptyView = RecordEmptyView()
                emptyView.recordButton
                    .rx.tap
                    .subscribe(with: self, onNext: { owner, event in
                        owner.navigationController?.tabBarController?.selectedIndex = 1
                    })
                    .disposed(by: self.disposeBag)
                owner.view = emptyView
            }
            else {
                owner.recordMemoListRelay.accept(event.1)
            }
        })
        .disposed(by: disposeBag)
    }
}
