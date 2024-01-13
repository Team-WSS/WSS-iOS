//
//  RecordResultView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class RecordResultView: UIView {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()

    //MARK: - UI Components
    
    private let headerView = RecordHeaderView()
    let recordTableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
        
        registerCell()
        bindDataToRecordTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        recordTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.contentInset.top = 24
            $0.contentInset.bottom = 24
        }
    }
    
    private func setHierachy() {
        self.addSubviews(headerView,
                         recordTableView)
    }
    
    private func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        recordTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func registerCell() {
        recordTableView.register(RecordTableViewCell.self,
                                 forCellReuseIdentifier: RecordTableViewCell.identifier)
    }
    
    private func bindDataToRecordTableView() {
        recordDummy.bind(to: recordTableView.rx.items(cellIdentifier: RecordTableViewCell.identifier, cellType: RecordTableViewCell.self)) { (row, element, cell) in
            cell.bindData(data: element)
        }
        .disposed(by: disposeBag)
    }
}
