//
//  NovelDetailViewController.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import RxSwift
import RxCocoa

final class NovelDetailViewController: UIViewController {
    
    private let memos = Observable<[[String: String]]>.just([
        ["memoDate": "2023-12-23 오전 10:12", "memoContent": "답을 모르겠어서 잠이나 자야겠다. 그러나 졸리지는 않다. 왜냐하면 UI를 아직 다 끝내지 못했기 때문이다. 별 하나의 추억과, 별 하나의 사랑과, 별하나의 어머니, 어머니, 어머님 당신은 북간도에 계십니다. 어머니, 어머니, 어머님 당신은 북간도에 계십니다. 어머니, 어머니, 어머님 당신은 북간도에 계"],
        ["memoDate": "2023-12-23 오전 10:12", "memoContent": "뿡"],
        ["memoDate": "2023-12-23 오전 10:12", "memoContent": "깨달았다. 사람은 사람을 절대 이해할 수 없다. 공감할수는 있어도. 그렇기에 나는 절대로 사람을 이해하려 노력하지 않을"]
    ])
    
    private let disposeBag = DisposeBag()
    private let memoTableViewHeight = BehaviorSubject<CGFloat>(value: 0)
    
    // MARK: - UI Components
    
    private let rootView = NovelDetailView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        bind()
    }
    
    // MARK: - register

    private func register() {
        rootView.novelDetailMemoView.memoTableView.register(NovelDetailMemoTableViewCell.self, forCellReuseIdentifier: "NovelDetailMemoTableViewCell")
    }
    
    // MARK: - bind
    
    private func bind() {
        memos.bind(to: rootView.novelDetailMemoView.memoTableView.rx.items(
            cellIdentifier: "NovelDetailMemoTableViewCell",
            cellType: NovelDetailMemoTableViewCell.self)) { row, element, cell in
                cell.selectionStyle = .none
                cell.bindData(date: element["memoDate"]!, content: element["memoContent"]!)
            }
            .disposed(by: disposeBag)
        
        rootView.novelDetailMemoView.memoTableView.rx.observe(CGSize.self, "contentSize")
            .map { $0?.height ?? 0 }
            .bind(to: memoTableViewHeight)
            .disposed(by: disposeBag)

        memoTableViewHeight
            .subscribe(onNext: { height in
                self.rootView.novelDetailMemoView.updateTableViewHeight(height: height)
            })
            .disposed(by: disposeBag)
    }
}
