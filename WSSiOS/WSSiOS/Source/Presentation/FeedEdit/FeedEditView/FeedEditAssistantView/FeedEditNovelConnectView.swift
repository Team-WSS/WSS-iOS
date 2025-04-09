//
//  FeedEditNovelConnectView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import SnapKit
import Then

final class FeedEditNovelConnectView: UIView {
    
    //MARK: - Components
    
    private let novelConnectTitleLabel = UILabel()
    private let novelConnectSubTitleLabel = UILabel()
    private let novelSearchView = UIView()
    private let novelSearchLabel = UILabel()
    private let searchImageView = UIImageView()
    
    //MARK: - Life Cycle
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        novelConnectTitleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.FeedEdit.Novel.novelConnect)
            $0.textColor = .wssBlack
        }
        
        novelConnectSubTitleLabel.do {
            $0.applyWSSFont(.body4, with: StringLiterals.FeedEdit.Novel.novelConnectSub)
            $0.textColor = .wssGray200
        }
        
        novelSearchView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
        }
        
        novelSearchLabel.do {
            $0.applyWSSFont(.label1, with: StringLiterals.FeedEdit.Novel.novelSearch)
            $0.textColor = .wssGray200
        }
        
        searchImageView.do {
            $0.image = .icSearch.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelConnectTitleLabel,
                         novelConnectSubTitleLabel,
                         novelSearchView)
        novelSearchView.addSubviews(novelSearchLabel,
                                    searchImageView)
    }
    
    private func setLayout() {
        novelConnectTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        novelConnectSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(novelConnectTitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(20)
        }
        
        novelSearchView.snp.makeConstraints {
            $0.top.equalTo(novelConnectSubTitleLabel.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        novelSearchLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
            $0.size.equalTo(25)
        }
    }
}
