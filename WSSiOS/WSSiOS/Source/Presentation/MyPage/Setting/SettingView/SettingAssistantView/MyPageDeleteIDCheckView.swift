//
//  MyPageDeleteIDCheckView.swift
//  WSSiOS
//
//  Created by 신지원 on 9/9/24.
//

import UIKit

import SnapKit
import Then

final class MyPageDeleteIDCheckView: UIView {
    
    //MARK: - Components
    
    private let checkTitleLabel = UILabel()
    var checkTableView = UITableView(frame: .zero, style: .plain)
    
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
        
        checkTitleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.MyPage.DeleteID.checkTitle)
            $0.textColor = .wssBlack
        }
        
        checkTableView.do {
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
    }
    private func setHierarchy() {
        self.addSubviews(checkTitleLabel,
                         checkTableView)
    }
    
    private func setLayout() {
        checkTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        checkTableView.snp.makeConstraints {
            $0.top.equalTo(checkTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(318)
        }
    } 
}
