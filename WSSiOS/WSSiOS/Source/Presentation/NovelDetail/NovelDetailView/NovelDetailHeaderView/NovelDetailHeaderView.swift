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
    let coverImageButton = NovelDetailHeaderCoverImageButton()
    private let novelInfoView = NovelDetailHeaderNovelInfoView()
    let reviewResultView = NovelDetailHeaderReviewResultView()
    let interestReviewButton = NovelDetailHeaderInterestFeedWriteButton()
    
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
        self.addSubview(stackView)
        stackView.addArrangedSubviews(bannerBackgroundImageView,
                                      coverImageButton,
                                      novelInfoView,
                                      reviewResultView,
                                      interestReviewButton)
    }
    
    private func setLayout() {
        bannerBackgroundImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(330)
        }
        
        stackView.do {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview().inset(24)
                $0.horizontalEdges.equalToSuperview()
            }
            
            $0.setCustomSpacing(-230, after: bannerBackgroundImageView)
            $0.setCustomSpacing(20, after: coverImageButton)
            $0.setCustomSpacing(20, after: novelInfoView)
            $0.setCustomSpacing(16, after: reviewResultView)
        }
        
        novelInfoView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        reviewResultView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        interestReviewButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderEntity) {
        bannerBackgroundImageView.bindData(data.novelImage)
        coverImageButton.bindData(data.novelImage, data.novelGenreImage)
        novelInfoView.bindData(data)
        interestReviewButton.updateInterestButtonState(data.isUserNovelInterest)
        reviewResultView.bindData(data)
    }
}
