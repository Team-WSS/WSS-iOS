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
    
    //MARK: - Components
    
    let alignmentView = LibraryListView()
    let headerView = RecordHeaderView()
    let recordTableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        recordTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.contentInset.top = 24
            $0.contentInset.bottom = 24
        }
        
        alignmentView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierachy() {
        self.addSubviews(headerView,
                         recordTableView,
                         alignmentView)
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
        
        alignmentView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(26)
            $0.width.equalTo(100)
            $0.height.equalTo(104)
        }
    }
}
