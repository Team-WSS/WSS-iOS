//
//  NovelDetailTabBarView.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/20/24.
//

//
//  NovelDetailHeaderInterestReviewButton.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/10/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailTabBarView: UIView {
    
    //MARK: - Properties
    
    private let animationDuration: Double = 0.25
    private let onColor: UIColor = .wssBlack
    private let offColor: UIColor = .wssGray200
    
    //MARK: - Components
    
    let infoButton = UIButton()
    private let infoLabel = UILabel()
    
    let feedButton = UIButton()
    private let feedLabel = UILabel()
    
    private let bottomLineView = UIView()
    private let highlightLineView = UIView()
    
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
        
        infoLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.NovelDetail.Tab.info)
            $0.isUserInteractionEnabled = false
        }
        
        feedLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.NovelDetail.Tab.feed)
            $0.isUserInteractionEnabled = false
        }
        
        bottomLineView.do {
            $0.backgroundColor = .wssGray70
        }
        
        highlightLineView.do {
            $0.backgroundColor = .black
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(infoButton,
                         feedButton,
                         bottomLineView,
                         highlightLineView)
        infoButton.addSubview(infoLabel)
        feedButton.addSubview(feedLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(54)
        }
        
        infoButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(52)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            
            infoLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        feedButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(52)
            $0.trailing.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            
            feedLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(infoButton.snp.bottom)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }
        
        highlightLineView.snp.makeConstraints {
            $0.top.equalTo(infoButton.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(infoButton.snp.leading)
            $0.width.equalToSuperview().dividedBy(2)
        }
    }
    
    //MARK: - Custom Method
    
    func updateTabBar(selected tab: Tab) {
        updateButtonTextColor(selected: tab)
        updateHilightLineView(selected: tab)
    }
    
    private func updateButtonTextColor(selected tab: Tab) {
        let isInfoSelected = tab == .info
        
        self.infoLabel.textColor = isInfoSelected ? self.onColor : self.offColor
        self.feedLabel.textColor = isInfoSelected ? self.offColor : self.onColor
    }
    
    private func updateHilightLineView(selected tab: Tab) {
        switch tab {
        case .info:
            self.highlightLineView.snp.remakeConstraints {
                $0.top.equalTo(self.infoButton.snp.bottom)
                $0.bottom.equalToSuperview()
                $0.leading.equalTo(self.infoButton.snp.leading)
                $0.width.equalToSuperview().dividedBy(2)
            }
        case .feed:
            self.highlightLineView.snp.remakeConstraints {
                $0.top.equalTo(self.infoButton.snp.bottom)
                $0.bottom.equalToSuperview()
                $0.leading.equalTo(self.feedButton.snp.leading)
                $0.width.equalToSuperview().dividedBy(2)
            }
        }
        self.layoutIfNeeded()
    }
}

enum Tab {
    case info, feed
}
