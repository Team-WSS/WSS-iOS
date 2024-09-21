//
//  NovelReviewSelectedKeywordCollectionViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/13/24.
//

import UIKit

import SnapKit
import Then

final class NovelReviewSelectedKeywordCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    
    private let keywordTag = KeywordTag()
    
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
        keywordTag.do {
            $0.backgroundColor = .wssPrimary50
        }
    }
    
    private func setHierarchy() {
        self.contentView.addSubview(keywordTag)
    }
    
    private func setLayout() {
        keywordTag.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(37)
        }
    }
    
    //MARK: - Data
    
    func bindData(keyword: String) {
        self.keywordTag.setText(keyword)
    }
}
