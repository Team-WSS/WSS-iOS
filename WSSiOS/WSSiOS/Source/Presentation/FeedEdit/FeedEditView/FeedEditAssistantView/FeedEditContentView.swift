//
//  FeedEditContentView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import SnapKit
import Then

final class FeedEditContentView: UIView {

    //MARK: - Components
    
    private let writeContentLabel = UILabel()
    private let essentialImageView = UIImageView()
    private let spoilerLabel = UILabel()
    let spoilerButton = WSSToggleButton()
    let feedTextWrapperView = UIView()
    let feedTextView = UITextView()
    let placeholderLabel = UILabel()
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
            $0.applyWSSFont(.title2, with: StringLiterals.FeedEdit.Content.writeContent)
            $0.textColor = .wssBlack
        }
        
        essentialImageView.do {
            $0.image = .icEssential
            $0.contentMode = .scaleAspectFit
        }
        
        spoilerLabel.do {
            $0.applyWSSFont(.label1, with: StringLiterals.FeedEdit.Content.spoiler)
            $0.textColor = .wssGray300
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
            $0.tintColor = .wssBlack
            $0.font = .Body2
        }
        
        placeholderLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.FeedEdit.Content.placeHolder)
            $0.textColor = .wssGray200
            $0.numberOfLines = 0
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
                                        placeholderLabel,
                                        letterCountLabel)
    }
    
    private func setLayout() {
        writeContentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(20)
        }
        
        essentialImageView.snp.makeConstraints {
            $0.top.equalTo(writeContentLabel.snp.top).offset(2)
            $0.leading.equalTo(writeContentLabel.snp.trailing).offset(2)
            $0.size.equalTo(8)
        }
        
        spoilerLabel.snp.makeConstraints {
            $0.centerY.equalTo(writeContentLabel.snp.centerY)
            $0.trailing.equalTo(spoilerButton.snp.leading).offset(-8)
        }
        
        spoilerButton.snp.makeConstraints {
            $0.centerY.equalTo(writeContentLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
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
        
        placeholderLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        letterCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(12.5)
        }
    }
    
    //MARK: - Data
    
    func bindData(feedContent: String) {
        // 현재 커서 위치
        let selectedRange = self.feedTextView.selectedRange
        
        self.feedTextView.do {
            $0.applyWSSFont(.body2, with: feedContent)
        }
        
        // 커서 위치 복원
        let cursorPosition = min(selectedRange.location, feedContent.count)
        self.feedTextView.selectedRange = NSRange(location: cursorPosition, length: 0)
        
        self.letterCountLabel.do {
            $0.applyWSSFont(.body2, with: "(\(feedContent.count)/2000)")
        }
    }
}
