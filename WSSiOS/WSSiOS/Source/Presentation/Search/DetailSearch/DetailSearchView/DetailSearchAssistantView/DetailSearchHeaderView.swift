//
//  DetailSearchHeaderView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/19/24.
//

import UIKit

import SnapKit
import Then

enum DetailSearchTab {
    case info, keyword
}

final class DetailSearchHeaderView: UIView {
    
    //MARK: - UI Components
    
    let infoLabel = UILabel()
    let keywordLabel = UILabel()
    let underLineView = UIView()
    let newImageView = UIImageView()
    
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
        
        keywordLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.DetailSearch.keyword)
            $0.textColor = .wssGray200
        }
        
        underLineView.do {
            $0.backgroundColor = .wssPrimary100
        }
        
        newImageView.do {
            $0.image = .icSeachNew.withTintColor(.wssWhite)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(infoLabel,
                         keywordLabel,
                         underLineView,
                         newImageView)
    }
    
    private func setLayout() {
        infoLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        keywordLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.top)
            $0.leading.equalTo(infoLabel.snp.trailing).offset(22.5)
            $0.trailing.bottom.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(keywordLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalTo(infoLabel.snp.horizontalEdges)
            $0.height.equalTo(2)
        }
        
        newImageView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.top)
            $0.leading.equalTo(infoLabel.snp.trailing).offset(3)
            $0.size.equalTo(4)
        }
    }
    
    //MARK: - Custom Method
    
    func updateTab(selected tab: DetailSearchTab) {
        updateTabTextColor(selected: tab)
        updateunderLineView(selected: tab)
    }
    
    private func updateTabTextColor(selected tab: DetailSearchTab) {
        let isInfoSelected = tab == .info
        
        self.infoLabel.textColor = isInfoSelected ? .wssPrimary100 : .wssGray200
        self.keywordLabel.textColor = isInfoSelected ? .wssGray200 : .wssPrimary100
    }
    
    private func updateunderLineView(selected tab: DetailSearchTab) {
        switch tab {
        case .info:
            self.underLineView.snp.remakeConstraints {
                $0.top.equalTo(self.infoLabel.snp.bottom)
                $0.horizontalEdges.equalTo(infoLabel.snp.horizontalEdges)
                $0.height.equalTo(2)
            }
        case .keyword:
            self.underLineView.snp.remakeConstraints {
                $0.top.equalTo(keywordLabel.snp.bottom)
                $0.horizontalEdges.equalTo(keywordLabel.snp.horizontalEdges)
                $0.height.equalTo(2)
            }
        }
        self.layoutIfNeeded()
    }
}
