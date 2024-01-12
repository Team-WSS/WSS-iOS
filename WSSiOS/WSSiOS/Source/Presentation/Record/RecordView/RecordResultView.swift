//
//  RecordResultView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

final class RecordResultView: UIView {
    
    //MARK: - UI Components
    
    private let headerView = RecordHeaderView()
    private let recordTableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
        
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        recordTableView.do {
            $0.rowHeight = 136
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
        
    }
}
