//
//  NovelDetailInfoKeywordCollectionViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoKeywordCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "NovelDetailInfoKeywordCollectionViewCell"
    
    // MARK: - UI Components
    
    private let keywordLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .Gray50
            $0.layer.cornerRadius = 18.5
        }
        
        keywordLabel.do {
            $0.font = .Body2
            $0.textColor = .Gray300
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.contentView.addSubviews(keywordLabel)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        keywordLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.leading.trailing.equalToSuperview().inset(13)
        }
    }
    
    // MARK: - bind data
    
    func bindData(keyword: String) {
        self.keywordLabel.text = "#\(keyword)"
    }
}
