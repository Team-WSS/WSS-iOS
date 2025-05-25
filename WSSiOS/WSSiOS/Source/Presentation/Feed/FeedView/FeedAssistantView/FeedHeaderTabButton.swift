//
//  FeedHeaderTabButton.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/22/25.
//

import UIKit

import SnapKit
import Then

final class FeedHeaderTabButton: UIButton {
    
    //MARK: - Properties
    
    let tab: FeedTab
    private let bottomLineHeight: CGFloat = 2
    
    //MARK: - Components
    
    private let tabLabel = UILabel()
    private let bottomLineView = UIView()
    
    // MARK: - Life Cycle
    
    init(feedTab: FeedTab) {
        self.tab = feedTab
        
        super.init(frame: .zero)
        
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
        
        tabLabel.do {
            $0.applyWSSFont(.headline1, with: tab.name)
        }
        
        bottomLineView.do {
            $0.backgroundColor = .wssBlack
            $0.layer.cornerRadius = bottomLineHeight/2
        }
    }
    
    private func setHierarchy() {
        addSubviews(tabLabel,
                    bottomLineView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        tabLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.bottom)
            $0.horizontalEdges.equalToSuperview().offset(1)    // 피그마 상으로 프레임보다 양쪽으로 1칸만큼 더 튀어나와 있음.
            $0.height.equalTo(bottomLineHeight)
        }
    }
    
    //MARK: - Custom Method
    
    func updateButton(selectedTab: FeedTab) {
        tabLabel.do {
            $0.textColor = selectedTab == tab ? .wssBlack : .wssGray100
        }
        
        bottomLineView.isHidden = selectedTab != tab
    }
}

