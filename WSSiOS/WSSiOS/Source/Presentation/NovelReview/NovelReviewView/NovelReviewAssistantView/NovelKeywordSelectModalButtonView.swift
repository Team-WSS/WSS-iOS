//
//  NovelKeywordSelectModalButtonView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class NovelKeywordSelectModalButtonView: UIView {
    
    //MARK: - Components
    
    let resetButton = UIButton()
    private let resetButtonTitleView = UIView()
    private let resetImageView = UIImageView()
    private let resetLabel = UILabel()
    let selectButton = UIButton()
    private let selectLabel = UILabel()
    
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
        resetButton.do {
            $0.backgroundColor = .wssGray50
        }
        
        resetButtonTitleView.do {
            $0.isUserInteractionEnabled = false
        }
        
        resetImageView.do {
            $0.image = .icReset
            $0.isUserInteractionEnabled = false
        }
        
        resetLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.NovelReview.KeywordSearch.reset)
            $0.textColor = .wssGray300
            $0.isUserInteractionEnabled = false
        }
        
        selectButton.do {
            $0.backgroundColor = .wssPrimary100
        }
        
        selectLabel.do {
            $0.textColor = .wssWhite
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(resetButton,
                         selectButton)
        resetButton.addSubview(resetButtonTitleView)
        resetButtonTitleView.addSubviews(resetImageView,
                                         resetLabel)
        selectButton.addSubview(selectLabel)
    }
    
    private func setLayout() {
        resetButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(133)
            $0.height.equalTo(62)
            
            resetButtonTitleView.snp.makeConstraints {
                $0.center.equalToSuperview()
                
                resetImageView.snp.makeConstraints {
                    $0.leading.centerY.equalToSuperview()
                    $0.size.equalTo(14)
                }
                
                resetLabel.snp.makeConstraints {
                    $0.top.trailing.bottom.equalToSuperview()
                    $0.leading.equalTo(resetImageView.snp.trailing).offset(4)
                }
            }
        }
        
        selectButton.snp.makeConstraints {
            $0.leading.equalTo(resetButton.snp.trailing)
            $0.top.trailing.bottom.equalToSuperview()
            $0.height.equalTo(62)
            
            selectLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    //MARK: - Custom Method
    
    func updateSelectLabelText(keywordCount: Int) {
        selectLabel.do {
            $0.applyWSSFont(.title2, with: "\(keywordCount)\(StringLiterals.NovelReview.KeywordSearch.selectButtonText)")
        }
    }
}
