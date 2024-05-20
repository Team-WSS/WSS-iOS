//
//  FeedNavigationView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/19/24.
//

import UIKit

import SnapKit
import Then

final class FeedNavigationView: UIView {
    
    //MARK: - Components
    
    private let navigationTitle = UILabel()
    private lazy var navigationResetButton = UIButton()
    
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
        
        navigationTitle.do {
            $0.text = StringLiterals.Navigation.Title.feed
            $0.makeAttribute(with: $0.text)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -1.2)
                .applyAttribute()
            $0.font = .HeadLine1
            $0.textColor = .wssBlack
        }
        
        navigationResetButton.do {
            $0.setImage(UIImage(resource: .icReset), for: .normal)
        }
    }
    
    private func setHierarchy() {
        addSubviews(navigationTitle,
                    navigationResetButton)
    }
    
    private func setLayout() {
        navigationTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        navigationResetButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(20)
        }
    }
}

