//
//  FeedContentView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import SnapKit
import Then

final class FeedContentView: UIView {

    //MARK: - Components
    
    private let writeContentLabel = UILabel()
    private let essentialImageView = UIImageView()
    private let spoilerLabel = UILabel()
    let spoilerButton = RegisterNormalToggleButton()
    private let feedTextWrapperView = UIView()
    let feedTextView = UITextView()
    private let letterCountLabel = UILabel()
    
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
        }
        
        writeContentLabel.do {
            $0.applyWSSFont(.title2, with: "내용 작성하기")
            $0.textColor = .wssBlack
        }
        
        essentialImageView.do {
            $0.image = .icEssential
            $0.contentMode = .scaleAspectFit
        }
        
        spoilerLabel.do {
            $0.applyWSSFont(.label1, with: "스포일러")
            $0.textColor = .wssGray300
        }
        
        spoilerButton.do {
            $0.updateToggle(false)
        }
        
        feedTextWrapperView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
        }
        
        feedTextView.do {
            $0.backgroundColor = .clear
            $0.textColor = .wssBlack
            $0.textContainer.lineFragmentPadding = 0
            $0.textContainerInset = .zero
        }
        
        letterCountLabel.do {
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(writeContentLabel,
                         essentialImageView,
                         spoilerLabel,
                         spoilerButton,
                         feedTextWrapperView)
        feedTextWrapperView.addSubviews(feedTextView,
                                        letterCountLabel)
    }
    
    private func setLayout() {
        writeContentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(20)
        }
        
        essentialImageView.snp.makeConstraints {
            $0.top.equalTo(writeContentLabel.snp.top).offset(2)
            $0.left.equalTo(writeContentLabel.snp.right).offset(2)
        }
        
        spoilerLabel.snp.makeConstraints {
            $0.centerY.equalTo(writeContentLabel.snp.centerY)
            $0.right.equalTo(spoilerButton.snp.left).offset(-8)
        }
        
        spoilerButton.snp.makeConstraints {
            $0.centerY.equalTo(writeContentLabel.snp.centerY)
            $0.right.equalToSuperview().inset(20)
        }
        
        feedTextWrapperView.snp.makeConstraints {
            $0.top.equalTo(writeContentLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(309)
        }
        
        feedTextView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(35.89)
        }
        
        letterCountLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(12.5)
        }
    }
    
    //MARK: - Data
    
    func bindData(memoContent: String) {
        self.feedTextView.do {
            $0.makeAttribute(with: memoContent)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
        }
        
        self.letterCountLabel.do {
            $0.applyWSSFont(.body2, with: "(\(memoContent.count)/2000)")
        }
    }
}
