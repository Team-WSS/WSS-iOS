//
//  NovelKeywordSelectSearchResultCollectionViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class NovelKeywordSelectSearchResultCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            self.keywordLink.updateColor(isSelected)
        }
    }
    
    //MARK: - Components
    
    private let keywordLink = KeywordLink()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setHierarchy() {
        self.contentView.addSubview(keywordLink)
    }
    
    private func setLayout() {
        keywordLink.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(35)
        }
    }
    
    //MARK: - Data
    
    func bindData(keyword: KeywordData) {
        self.keywordLink.setText(keyword.keywordName)
    }
}
