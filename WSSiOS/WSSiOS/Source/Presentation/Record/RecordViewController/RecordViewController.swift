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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindDataToRecordTableView()
        setNavigationBar()
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
//    
//    private func registerCell() {
//        rootView.recordTableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.identifier)
//    }
//    
    func transform(disposeBag: DisposeBag, completion: @escaping (Int, [RecordMemo]) -> Void) {
        self.memoRepository.getRecordMemoList()
            .subscribe (
                onNext: { [weak self] memo in
                    guard self != nil else { return }
                    let recordMemoCount = memo.memoCount
                    let recordMemoList = memo.memos
                    
                    completion(recordMemoCount, recordMemoList)
                    
                    print(recordMemoCount)
                    print(recordMemoList)
                },
                onError: { error in
                    print(error)
                })
            .disposed(by: disposeBag)
    }

    private func bindDataToUI() {
        self.transform(disposeBag: disposeBag) { [weak self] recordMemoCount, recordMemoList in
            // 뷰 컨트롤러에서 전달받은 데이터 처리
            self?.updateUI(recordMemoCount: recordMemoCount, recordMemoList: recordMemoList)
        }
    }
    
    private func bindDataToRecordTableView() {
        recordMemoListRelay
            .bind(to: rootView.recordTableView.rx.items(cellIdentifier: RecordTableViewCell.identifier, cellType: RecordTableViewCell.self)) { (row, element, cell) in
                cell.bindData(data: element)
            }
            .disposed(by: disposeBag)
    }
    
    func updateUI(recordMemoCount: Int, recordMemoList: [RecordMemo]) {
        // UI 로직 구현
        Observable.combineLatest(
            Observable.just(recordMemoCount),
            Observable.just(recordMemoList)
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] count, list in
            self?.rootView.headerView.recordCountLabel.text = "\(count)개"
            self?.recordMemoListRelay.accept(list)
        })
        .disposed(by: disposeBag)
    }
}
