//
//  FeedDetailNovelStarView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/29/25.
//

import UIKit

import SnapKit
import Then

final class FeedDetailNovelStarView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    
    private let novelUserStarTitleLabel = UILabel()
    private let novelUserStarImageView = UIImageView()
    private let novelUserStarCountLabel = UILabel()
    
    private let novelTotalStarTitleLabel = UILabel()
    private let novelTotalStarImageView = UIImageView()
    private let novelTotalStarCountLabel = UILabel()
    
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
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        
        novelUserStarTitleLabel.do {
            $0.textColor = .wssGray300
            $0.applyWSSFont(.body5, with: StringLiterals.FeedDetail.userStarTitle)
        }
        
        novelUserStarImageView.do {
            $0.tintColor = .wssSecondary100
            $0.image = .icStar.withTintColor(.wssSecondary100, renderingMode: .alwaysTemplate)
        }
        
        novelUserStarCountLabel.do {
            $0.textColor = .wssSecondary100
        }
        
        novelTotalStarTitleLabel.do {
            $0.textColor = .wssGray200
            $0.applyWSSFont(.body5, with: StringLiterals.FeedDetail.totalStarTitle)
        }
        
        novelTotalStarImageView.do {
            $0.tintColor = .wssGray200
            $0.image = .icStar.withTintColor(.wssGray200, renderingMode: .alwaysTemplate)
        }
        
        novelTotalStarCountLabel.do {
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubviews(novelUserStarTitleLabel,
                                      novelUserStarImageView,
                                      novelUserStarCountLabel,
                                      novelTotalStarTitleLabel,
                                      novelTotalStarImageView,
                                      novelTotalStarCountLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.do {
            $0.setCustomSpacing(2, after: novelUserStarTitleLabel)
            $0.setCustomSpacing(2, after: novelUserStarImageView)
            $0.setCustomSpacing(8, after: novelUserStarCountLabel)
            $0.setCustomSpacing(2, after: novelTotalStarTitleLabel)
            $0.setCustomSpacing(2, after: novelTotalStarImageView)
        }
        
        novelUserStarTitleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
        }
        
        novelUserStarImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
        
        novelTotalStarImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
    }
    
    //MARK: - Data
    
    func bindData(userCount: Float, totalCount: Float) {
        novelUserStarCountLabel.applyWSSFont(.body5_2, with: String(userCount))
        novelTotalStarCountLabel.applyWSSFont(.body5_2, with: String(totalCount))
    }
}
