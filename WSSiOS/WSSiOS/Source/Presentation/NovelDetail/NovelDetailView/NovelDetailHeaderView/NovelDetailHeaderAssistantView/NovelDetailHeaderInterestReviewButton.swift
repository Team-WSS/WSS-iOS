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
    private let buttonStackView = UIStackView()
    
    private let interestButton = UIButton()
    private let interestContentView = UIView()
    private let interestImageView = UIImageView()
    private let interestLabel = UILabel()
    
    private let reviewButton = UIButton()
    private let reviewContentView = UIView()
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
        buttonStackView.do {
            $0.spacing = 8
            $0.distribution = .fillEqually
            $0.alignment = .center
        }
        
        interestButton.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 15
            $0.layer.borderColor = UIColor.wssPrimary100.cgColor
            $0.layer.borderWidth = 1
            
            interestContentView.do {
                $0.isUserInteractionEnabled = false
                
                interestImageView.do {
                    $0.image = .icReviewNotInterest
                }
                
                interestLabel.do {
                    $0.applyWSSFont(.body4, with: StringLiterals.NovelDetail.Header.interest)
                    $0.textColor = .wssPrimary100
                }
            }
        }
        
        reviewButton.do {
            $0.backgroundColor = .wssPrimary100
            $0.layer.cornerRadius = 15
            
            reviewContentView.do {
                $0.isUserInteractionEnabled = false
                
                reviewImageView.do {
                    $0.image = .icReviewWrite
                }
                
                reviewLabel.do {
                    $0.applyWSSFont(.body4, with: StringLiterals.NovelDetail.Header.review)
                    $0.textColor = .wssWhite
                }
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(buttonStackView)
        buttonStackView.addArrangedSubviews(interestButton,
                         reviewButton)
        interestButton.addSubview(interestContentView)
        interestContentView.addSubviews(interestImageView,
                                        interestLabel)
        reviewButton.addSubview(reviewContentView)
        reviewContentView.addSubviews(reviewImageView,
                                      reviewLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        interestButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            
            interestContentView.snp.makeConstraints {
                $0.center.equalToSuperview()
                
                interestImageView.snp.makeConstraints {
                    $0.leading.equalToSuperview()
                    $0.size.equalTo(20)
                    $0.verticalEdges.equalToSuperview()
                }
                
                interestLabel.snp.makeConstraints {
                    $0.leading.equalTo(interestImageView.snp.trailing).offset(9)
                    $0.centerY.equalToSuperview()
                    $0.trailing.equalToSuperview().inset(6)
                }
            }
        }
        
        
        reviewButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            
            reviewContentView.snp.makeConstraints {
                $0.center.equalToSuperview()
                
                reviewImageView.snp.makeConstraints {
                    $0.leading.equalToSuperview()
                    $0.size.equalTo(20)
                    $0.verticalEdges.equalToSuperview()
                }
                
                reviewLabel.snp.makeConstraints {
                    $0.leading.equalTo(reviewImageView.snp.trailing).offset(9)
                    $0.centerY.equalToSuperview()
                    $0.trailing.equalToSuperview().inset(6)
                }
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderResult) {
        if data.isUserNovelInterest {
            interestButton.backgroundColor = .wssPrimary50
            interestImageView.image = .icReviewInterest
        } else {
            interestButton.backgroundColor = .wssWhite
            interestImageView.image = .icReviewNotInterest
        }
    }
}
