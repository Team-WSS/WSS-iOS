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
    
    let bannerImageView = RegisterNormalBannerImageView()
    let infoWithRatingView = RegisterNormalNovelInfoWithRatingView()
    let readStatusView = RegisterNormalReadStatusView()
    let readDateView = RegisterNormalReadDateView()
    private let dividerView = RegisterNormalDividerView()
    private let keywordSelectionView = RegisterNormalKeywordSelectionView()
    private let novelSummaryView = RegisterNormalNovelSummaryView()
    private let registerButton = WSSMainButton(title: "내 서재에 등록")
    private let registerButtonGradient = UIImageView()
    private let registerButtonBackgroundView = UIView()
    
    let customDatePicker = RegisterNormalCustomDatePicker()
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
            $0.showsHorizontalScrollIndicator = false
            
            pageContentView.do {
                $0.axis = .vertical
                $0.alignment = .fill
            }
        }
        
        registerButtonGradient.do {
            $0.image = .registerNormalButtonGradientDummy
        }
        
        registerButtonBackgroundView.do {
            $0.backgroundColor = .White
        }
    }
    
    private func setHieararchy() {
        self.addSubviews(pageScrollView,
                         registerButtonGradient,
                         registerButtonBackgroundView,
                         registerButton,
                         customDatePicker)
        pageScrollView.addSubview(pageContentView)
        pageContentView.addArrangedSubviews(bannerImageView,
                                            infoWithRatingView,
                                            readStatusView,
                                            readDateView,
                                            dividerView,
                                            keywordSelectionView,
                                            novelSummaryView)
    }
    
    private func setLayout() {
        pageScrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(registerButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            
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
        
        registerButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        registerButtonGradient.snp.makeConstraints {
            $0.bottom.equalTo(registerButton.snp.top)
            $0.height.equalTo(34)
            $0.horizontalEdges.equalToSuperview()
        }
        
        registerButtonBackgroundView.snp.makeConstraints {
            $0.top.equalTo(registerButton.snp.top)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        customDatePicker.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
