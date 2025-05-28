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
        stackView.addArrangedSubviews(novelUserStarImageView,
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
            $0.setCustomSpacing(2, after: novelUserStarImageView)
            $0.setCustomSpacing(8, after: novelUserStarCountLabel)
            $0.setCustomSpacing(2, after: novelTotalStarTitleLabel)
            $0.setCustomSpacing(2, after: novelTotalStarImageView)
        }

        novelUserStarImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
        
        novelTotalStarImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
    }
    
    //MARK: - Data
    
    func bindData(hasUserCount: Bool, userCount: Float?, totalCount: Float?) {
        if hasUserCount {
            novelUserStarCountLabel.applyWSSFont(.body5_2, with: String(userCount ?? 0.0))
        } else {
            [novelUserStarImageView,
             novelUserStarCountLabel].forEach {
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
        }
        novelTotalStarCountLabel.applyWSSFont(.body5_2, with: String(totalCount ?? 0.0))
    }
}
