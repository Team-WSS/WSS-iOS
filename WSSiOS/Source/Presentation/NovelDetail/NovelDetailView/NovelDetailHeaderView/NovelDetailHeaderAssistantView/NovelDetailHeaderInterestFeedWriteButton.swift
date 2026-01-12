//
//  NovelDetailHeaderInterestFeedWriteButton.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/10/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderInterestFeedWriteButton: UIView {
    
    //MARK: - Components
    
    private let buttonStackView = UIStackView()
    
    let interestButton = UIButton()
    private let interestContentView = UIView()
    private let interestImageView = UIImageView()
    private let interestLabel = UILabel()
    
    let feedWriteButton = UIButton()
    private let feedWriteContentView = UIView()
    private let feedWriteImageView = UIImageView()
    private let feedWriteLabel = UILabel()
    
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
        
        feedWriteButton.do {
            $0.backgroundColor = .wssPrimary100
            $0.layer.cornerRadius = 15
            
            feedWriteContentView.do {
                $0.isUserInteractionEnabled = false
                
                feedWriteImageView.do {
                    $0.image = .icReviewWrite
                }
                
                feedWriteLabel.do {
                    $0.applyWSSFont(.body4, with: StringLiterals.NovelDetail.Header.feedWrite)
                    $0.textColor = .wssWhite
                }
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(buttonStackView)
        buttonStackView.addArrangedSubviews(interestButton,
                                            feedWriteButton)
        interestButton.addSubview(interestContentView)
        interestContentView.addSubviews(interestImageView,
                                        interestLabel)
        feedWriteButton.addSubview(feedWriteContentView)
        feedWriteContentView.addSubviews(feedWriteImageView,
                                      feedWriteLabel)
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
        
        feedWriteButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            
            feedWriteContentView.snp.makeConstraints {
                $0.center.equalToSuperview()
                
                feedWriteImageView.snp.makeConstraints {
                    $0.leading.equalToSuperview()
                    $0.size.equalTo(20)
                    $0.verticalEdges.equalToSuperview()
                }
                
                feedWriteLabel.snp.makeConstraints {
                    $0.leading.equalTo(feedWriteImageView.snp.trailing).offset(9)
                    $0.centerY.equalToSuperview()
                    $0.trailing.equalToSuperview().inset(6)
                }
            }
        }
    }
    
    //MARK: - Data
    
    func updateInterestButtonState(_ isUserNovelInterest: Bool) {
        if isUserNovelInterest {
            interestButton.backgroundColor = .wssPrimary50
            interestImageView.image = .icReviewInterest
        } else {
            interestButton.backgroundColor = .wssWhite
            interestImageView.image = .icReviewNotInterest
        }
    }
}
