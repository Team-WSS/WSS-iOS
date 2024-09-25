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
    
    var blockTableView = UITableView(frame: .zero, style: .plain)
    
    let emptyView = UIView()
    private let emptyImageView = UIImageView()
    private let emptyLabel = UILabel()
    
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
        
        blockTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = true
            $0.separatorStyle = .singleLine
            $0.separatorColor = .wssGray50
            $0.rowHeight = 70
        }
        
        emptyView.do {
            $0.backgroundColor = .wssWhite
            $0.isHidden = true
            
            emptyImageView.do {
                $0.image = .imgEmptyCat
                $0.contentMode = .scaleAspectFit
            }
            
            emptyLabel.do {
                $0.textColor = .wssGray200
                $0.textAlignment = .center
                $0.applyWSSFont(.body2, with: StringLiterals.MyPage.BlockUser.emptyLabel)
            }
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft, for: .normal)
            $0.tintColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(blockTableView,
                         emptyView)
        emptyView.addSubviews(emptyImageView,
                              emptyLabel)
    }
    
    private func setLayout() {
        blockTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
            emptyImageView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(166)
                $0.height.equalTo(160)
            }
            
            emptyLabel.snp.makeConstraints {
                $0.top.equalTo(emptyImageView.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
            }
        }
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
}
