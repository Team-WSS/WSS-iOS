//
//  DetailSearchHeaderView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/19/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchHeaderView: UIView {
    
    //MARK: - UI Components
    
    private let infoLabel = UILabel()
    private let infoUnderLineView = UIView()
    
    private let keywordLabel = UILabel()
    private let keywordUnderLineView = UIView()
    
    private let newImageView = UIImageView()
    
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
        infoLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.DetailSearch.info)
            $0.textColor = .wssPrimary100
        }
        
        
        infoUnderLineView.do {
            $0.backgroundColor = .wssPrimary100
        }
        
        
        keywordLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.DetailSearch.keyword)
            $0.textColor = .wssGray200
        }
        
        keywordUnderLineView.do {
            $0.backgroundColor = .wssWhite
        }
        
        newImageView.do {
            $0.image = .icSeachNew
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(infoLabel,
                         infoUnderLineView,
                         newImageView,
                         keywordLabel,
                         keywordUnderLineView)
    }
    
    private func setLayout() {
        infoLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        infoUnderLineView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalTo(infoLabel.snp.horizontalEdges)
            $0.height.equalTo(2)
        }
        
        newImageView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.top)
            $0.leading.equalTo(infoLabel.snp.trailing).offset(3)
            $0.size.equalTo(4)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.top)
            $0.leading.equalTo(infoLabel.snp.trailing).offset(22.5)
            $0.trailing.bottom.equalToSuperview()
        }
        
        keywordUnderLineView.snp.makeConstraints {
            $0.top.equalTo(keywordLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalTo(keywordLabel.snp.horizontalEdges)
            $0.height.equalTo(2)
        }
    }
}
