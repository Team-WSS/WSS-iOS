//
//  SosoPickCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/26/24.
//

import UIKit

import SnapKit
import Then

final class SosoPickCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    
    private let novelImageView = UIImageView()
    private let novelTitleLabel = UILabel()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        novelImageView.do {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        
        novelTitleLabel.do {
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelImageView,
                         novelTitleLabel)
    }
    
    private func setLayout() {
        novelImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalTo(121)
            $0.height.equalTo(179)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(novelImageView.snp.bottom).offset(8)
            $0.leading.equalTo(novelImageView.snp.leading)
            $0.width.equalTo(novelImageView.snp.width)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bindData(data: SosoPickNovel) {
        self.novelImageView.image = UIImage(named: data.novelImage)
        self.novelTitleLabel.do {
            $0.applyWSSFont(.label1, with: data.novelTitle)
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
    }
}
