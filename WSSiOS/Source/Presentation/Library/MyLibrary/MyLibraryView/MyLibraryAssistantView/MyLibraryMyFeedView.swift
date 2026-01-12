//
//  MyLibraryMyFeedView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/27/25.
//

import UIKit

import SnapKit
import Then

final class MyLibraryMyFeedView: UIView {
    
    //MARK: - Components
    
    let feedTextLabel = UILabel()
    let leftQuoteImageView = UIImageView()
    let rightQuoteImageView = UIImageView()
    
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
        self.do {
            $0.backgroundColor = .wssPrimary50
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.wssGray70.cgColor
        }
        
        feedTextLabel.do {
            $0.textColor = .wssBlack
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        
        leftQuoteImageView.do {
            $0.image = .icDoubleQuoteLeft
        }
        
        rightQuoteImageView.do {
            $0.image = .icDoubleQuoteRight
        }
    }

    private func setHierarchy() {
        self.addSubviews(feedTextLabel,
                         leftQuoteImageView,
                         rightQuoteImageView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(310)
            $0.height.equalTo(54)
        }
        
        feedTextLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(leftQuoteImageView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(rightQuoteImageView.snp.leading).offset(-8)
        }
        
        leftQuoteImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13.5)
            $0.leading.equalToSuperview().inset(21)
            $0.width.equalTo(16)
            $0.height.equalTo(9)
        }
        
        rightQuoteImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12.5)
            $0.trailing.equalToSuperview().inset(21)
            $0.width.equalTo(16)
            $0.height.equalTo(9)
        }
    }
    
    func bindData(feed: String) {
        feedTextLabel.do {
            $0.applyWSSFont(.body5, with: feed)
        }
    }
}
