//
//  SosoFeedHeaderView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/19/24.
//

import UIKit

import SnapKit
import Then

final class SosoFeedHeaderView: UIView {
    
    //MARK: - Properties
    
    private let buttonHeight: CGFloat = 33
    
    //MARK: - Components
    
    let allTabButton = UIButton()
    private let allTabLabel = UILabel()
    
    let recommendedTabButton = UIButton()
    private let recommendedTabLabel = UILabel()
    private let recommendedTabImageView = UIImageView()
    
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
        self.backgroundColor = .wssWhite
        
        allTabButton.do {
            $0.layer.cornerRadius = buttonHeight/2
            $0.layer.borderWidth = 1
        }
        
        allTabLabel.do {
            $0.applyWSSFont(.body4, with: SosoFeedTab.all.text)
            $0.isUserInteractionEnabled = false
        }
        
        recommendedTabButton.do {
            $0.layer.cornerRadius = buttonHeight/2
            $0.layer.borderWidth = 1
        }
        
        recommendedTabLabel.do {
            $0.applyWSSFont(.body4, with: SosoFeedTab.recommended.text)
            $0.isUserInteractionEnabled = false
        }
        
        recommendedTabImageView.do {
            $0.image = .icHot
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        addSubviews(allTabButton,
                    recommendedTabButton)
        allTabButton.addSubview(allTabLabel)
        recommendedTabButton.addSubviews(recommendedTabLabel,
                                         recommendedTabImageView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(57)
        }
        
        allTabButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            
            allTabLabel.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview().inset(7)
                $0.horizontalEdges.equalToSuperview().inset(13)
            }
        }
        
        recommendedTabButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(allTabButton.snp.trailing).offset(6)
            
            recommendedTabImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(13)
                $0.centerY.equalToSuperview()
                $0.size.equalTo(16)
            }
            
            recommendedTabLabel.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview().inset(7)
                $0.leading.equalTo(recommendedTabImageView.snp.trailing).offset(4)
                $0.trailing.equalToSuperview().inset(13)
            }
        }
    }
    
    func updateButtons(selectedTab: SosoFeedTab) {
        allTabButton.do {
            $0.layer.borderColor = selectedTab == .all ? UIColor.wssBlack.cgColor : UIColor.wssGray80.cgColor
            $0.backgroundColor = selectedTab == .all ? .wssBlack : .wssWhite
        }
        
        allTabLabel.do {
            $0.textColor = selectedTab == .all ? .wssWhite : .wssGray300
        }
        
        recommendedTabButton.do {
            $0.layer.borderColor = selectedTab == .recommended ? UIColor.wssBlack.cgColor : UIColor.wssGray80.cgColor
            $0.backgroundColor = selectedTab == .recommended ? .wssBlack : .wssWhite
        }
        
        recommendedTabLabel.do {
            $0.textColor = selectedTab == .recommended ? .wssWhite : .wssGray300
        }
    }
}

