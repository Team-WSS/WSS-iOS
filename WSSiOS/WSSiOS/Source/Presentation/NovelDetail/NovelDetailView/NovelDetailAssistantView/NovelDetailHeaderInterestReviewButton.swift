//
//  NovelDetailHeaderInterestReviewButton.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/10/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderInterestReviewButton: UIView {
    
    //MARK: - Components
    
    private let interestButton = UIButton()
    private let interestStackView = UIStackView()
    private let intersetImageView = UIImageView()
    private let interestLabel = UILabel()
    
    private let dividerView = UIView()
    
    private let reviewButton = UIButton()
    private let reviewStackView = UIStackView()
    private let reviewImageView = UIImageView()
    private let reviewLabel = UILabel()
    
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
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.layer.borderWidth = 1
        }
        
        interestStackView.do {
            $0.axis = .horizontal
            $0.spacing = 9
            $0.alignment = .center
            $0.isUserInteractionEnabled = false
            
            intersetImageView.do {
                $0.image = .icReviewNotInterest
            }
            
            interestLabel.do {
                $0.applyWSSFont(.body5, with: StringLiterals.NovelDetail.Header.interest)
                $0.textColor = .wssGray300
            }
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray70
        }
        
        reviewStackView.do {
            $0.axis = .horizontal
            $0.spacing = 9
            $0.alignment = .center
            $0.isUserInteractionEnabled = false
            
            reviewImageView.do {
                $0.image = .icReviewWrite
            }
            
            reviewLabel.do {
                $0.applyWSSFont(.body5, with: StringLiterals.NovelDetail.Header.review)
                $0.textColor = .wssGray300
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(interestButton,
                         dividerView,
                         reviewButton)
        interestButton.addSubview(interestStackView)
        interestStackView.addArrangedSubviews(intersetImageView,
                                              interestLabel)
        reviewButton.addSubview(reviewStackView)
        reviewStackView.addArrangedSubviews(reviewImageView,
                                            reviewLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        interestButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(dividerView.snp.centerX)
        }
        
        interestStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(25)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(1)
        }
        
        reviewButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(dividerView.snp.centerX)
            $0.trailing.equalToSuperview()
        }
        
        reviewStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: DetailBasicResult) {
        if data.isUserNovelInterest {
            intersetImageView.image = .icReviewInterest
            interestLabel.textColor = .wssPrimary200
        } else {
            intersetImageView.image = .icReviewNotInterest
            interestLabel.textColor = .wssGray300
        }
    }
}
