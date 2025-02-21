//
//  NovelDetailInfoReviewKeywordCollectionViewCell.swift
//  WSSiOS
//
//  Created by 이윤학 on 7/3/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReviewKeywordCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Components
    
    private let keywordLabel = KeywordLabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setHierarchy() {
        self.addSubview(keywordLabel)
    }
    
    private func setLayout() {
        keywordLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindData(data: KeywordEntity) {
        keywordLabel.setText("\(data.keywordName) \(data.keywordCount)")
    }
}
