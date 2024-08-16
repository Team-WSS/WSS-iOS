//
//  NovelDetailInfoReviewEmptyView.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/30/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReviewEmptyView: UIView {
    
    //MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let reviewEmptyImageView = UIImageView()
    private let reviewEmptyLabel = UILabel()
    
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
        
        titleLabel.do {
            $0.applyWSSFont(.title1,
                            with: StringLiterals.NovelDetail.Info.reviewEmpty)
            $0.textColor = .wssBlack
        }

        reviewEmptyImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = .imgReviewEmpty
        }
        
        reviewEmptyLabel.do {
            $0.applyWSSFont(.body2,
                            with: StringLiterals.NovelDetail.Info.reviewEmptyDescription)
            $0.textColor = .wssGray200
            $0.numberOfLines = 2
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         reviewEmptyImageView,
                         reviewEmptyLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(35)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        reviewEmptyImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(160)
        }
        
        reviewEmptyLabel.snp.makeConstraints {
            $0.top.equalTo(reviewEmptyImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(70)
        }
    }
}
