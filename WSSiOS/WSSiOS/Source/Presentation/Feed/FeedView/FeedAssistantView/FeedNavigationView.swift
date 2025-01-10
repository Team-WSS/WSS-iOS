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
    let createFeedButton = UIButton()
    
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
            $0.applyWSSFont(.headline1, with: StringLiterals.Navigation.Title.feed)
            $0.textColor = .wssBlack
        }
        
        createFeedButton.do {
            $0.setImage(.icPencilSmall.withTintColor(.wssBlack).withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func setHierarchy() {
        addSubviews(navigationTitle,
                    createFeedButton)
    }
    
    private func setLayout() {
        navigationTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        createFeedButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(20)
        }
    }
}

