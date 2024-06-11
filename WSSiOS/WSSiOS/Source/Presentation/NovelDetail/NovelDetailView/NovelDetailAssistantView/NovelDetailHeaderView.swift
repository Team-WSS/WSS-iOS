//
//  NovelDetailHeaderView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderView: UIView {
    
    //MARK: - Components
    
    private let bannerBackgroundImageView = NovelDetailHeaderBackgroundImageView()
    
    private let stackView = UIStackView()
    private let novelCoverImageView = NovelDetailHeaderCoverImageView()
    private let novelInfoView = NovelDetailHeaderInfoView()
    private let novelEstimateButton = NovelDetailHeaderRatingButton()
    private let novelInterestReviewButton = NovelDetailHeaderInterestReviewButton()
    
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
        self.backgroundColor = .wssGray50
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(bannerBackgroundImageView,
                         stackView)
        stackView.addArrangedSubviews(novelCoverImageView,
                                      novelInfoView,
                                      novelEstimateButton,
                                      novelInterestReviewButton)
    }
    
    private func setLayout() {
        bannerBackgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(248)
        }
        
        stackView.do {
            $0.snp.makeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(16)
            }
            
            $0.setCustomSpacing(20, after: novelCoverImageView)
            $0.setCustomSpacing(26, after: novelInfoView)
            $0.setCustomSpacing(6, after: novelEstimateButton)
        }
        
        novelEstimateButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        novelInterestReviewButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailBasicResult) {
        bannerBackgroundImageView.bindData(data)
        novelCoverImageView.bindData(data)
        novelInfoView.bindData(data)
        novelInterestReviewButton.bindData(data)
    }
}
