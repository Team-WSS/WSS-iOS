//
//  LibraryFilterTabButton.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterTabButton: UIButton {
    
    //MARK: - Properties
    
    let tab: LibraryFilterTab
    
    //MARK: - UI Components
    
    private let tabTitleLabel = UILabel()
    private let dotView = UIView()
    private let underlineView = UIView()
    
    //MARK: - Life Cycle
    
    init(_ tab: LibraryFilterTab) {
        self.tab = tab
        
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        tabTitleLabel.do {
            $0.applyWSSFont(.title2, with: tab.title)
            $0.textColor = .wssGray300
            $0.isUserInteractionEnabled = false
        }
        
        dotView.do {
            $0.backgroundColor = .wssPrimary100
            $0.layer.cornerRadius = 2
            $0.isHidden = true
            $0.isUserInteractionEnabled = false
        }
        
        underlineView.do {
            $0.backgroundColor = .wssBlack
            $0.isHidden = true
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(tabTitleLabel,
                         dotView,
                         underlineView)
    }
    
    private func setLayout() {
        tabTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        dotView.snp.makeConstraints {
            $0.top.equalTo(tabTitleLabel.snp.top)
            $0.size.equalTo(4)
            $0.leading.equalTo(tabTitleLabel.snp.trailing).offset(3)
            $0.trailing.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints {
            $0.top.equalTo(tabTitleLabel.snp.bottom).offset(6)
            $0.height.equalTo(2)
            $0.leading.equalTo(tabTitleLabel.snp.leading)
            $0.trailing.equalTo(tabTitleLabel.snp.trailing)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func setSelected(_ isSelected: Bool) {
        tabTitleLabel.textColor = isSelected ? .wssBlack : .wssGray300
        underlineView.isHidden = !isSelected
    }
    
    func setDot(_ visible: Bool) {
        dotView.isHidden = !visible
    }
}
