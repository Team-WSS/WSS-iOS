//
//  HomeNoticeView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import UIKit

import SnapKit
import Then

final class HomeNoticeView: UIView {
    
    //MARK: - UI Components
    
    let noticeTableView = UITableView(frame: .zero, style: .plain)
    let testview = HomeNoticeTableViewCell()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        noticeTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
    }
    
    private func setHierarchy() {
        self.addSubview(testview)
    }
    
    private func setLayout() {
        testview.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(110)
        }
    }
}
