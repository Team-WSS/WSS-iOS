//
//  MyFeedFilterHeaderView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/25/25.
//

import UIKit

import SnapKit
import Then

final class MyFeedFilterHeaderView: UIView {
    
    //MARK: - Components
    
    let filterButton = WSSFilterButton()
    
    let sortButton = UIButton()
    let sortButtonLabel = UILabel()
    let sortButtonImageView = UIImageView()
    
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
        
        filterButton.do {
            $0.setImageHidden(isHidden: false)
            $0.setButtonText(StringLiterals.Feed.novelCountText(1028))
            $0.updateButton(isSelected: true)
        }
        
        sortButtonLabel.do {
            $0.textColor = .wssGray300
            $0.isUserInteractionEnabled = false
        }
        
        sortButtonImageView.do {
            $0.image = .icSwitch
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        addSubviews(filterButton,
                    sortButton)
        sortButton.addSubviews(sortButtonLabel,
                               sortButtonImageView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(57)
        }
        
        filterButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        sortButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(33)
            
            sortButtonLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
            
            sortButtonImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalTo(sortButtonLabel.snp.leading).offset(-4)
                $0.leading.equalToSuperview()
                $0.size.equalTo(16)
            }
        }
    }
    
    func updateSortButton(sortType: SortType) {
        sortButtonLabel.applyWSSFont(.body3, with: sortType.text)
    }
}

