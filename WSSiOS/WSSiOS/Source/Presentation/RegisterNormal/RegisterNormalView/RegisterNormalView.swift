//
//  RegisterNormalView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/6/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalView: UIView {
    
    // MARK: - UI Components
    
    private let pageScrollView = UIScrollView()
    private let pageContentView = UIStackView()
    
    private let bannerImageView = RegisterNormalBannerImageView()
    private let infoWithRatingView = RegisterNormalNovelInfoWithRatingView()
    private let readStatusView = RegisterNormalReadStatusView()
    private let readDateView = RegisterNormalReadDateView()
    private let dividerView = RegisterNormalDividerView()
    private let keywordSelectionView = RegisterNormalKeywordSelectionView()
    private let novelSummaryView = RegisterNormalNovelSummaryView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .white
        }
        pageScrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
        }
        pageContentView.do {
            $0.axis = .vertical
            $0.alignment = .fill
        }
    }
    
    private func setHieararchy() {
        self.addSubviews(pageScrollView)
        
        pageScrollView.addSubview(pageContentView)
        
        pageContentView.addArrangedSubviews(
            bannerImageView, infoWithRatingView, readStatusView, readDateView, dividerView, keywordSelectionView, novelSummaryView
        )
    }
    
    private func setLayout() {
        pageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageContentView.do {
            $0.snp.makeConstraints {
                $0.edges.equalTo(pageScrollView.contentLayoutGuide)
                $0.width.equalToSuperview()
            }
            
            $0.spacing = 35
            $0.setCustomSpacing(-154, after: bannerImageView)
            $0.setCustomSpacing(56, after: infoWithRatingView)
        }
    }
}
