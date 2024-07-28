//
//  MyPageBlockUserView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/29/24.
//

import UIKit

import SnapKit
import Then

final class MyPageBlockUserView: UIView {
    
    //MARK: - Components
    
    var tableView = UITableView(frame: .zero, style: .plain)
    lazy var backButton = UIButton()
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .wssWhite
        
        tableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = true
            $0.separatorStyle = .singleLine
            $0.separatorColor = .wssGray50
            $0.rowHeight = 70
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft, for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(tableView)
    }
    
    private func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
    }
}
