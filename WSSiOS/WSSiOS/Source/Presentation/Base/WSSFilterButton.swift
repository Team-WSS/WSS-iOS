//
//  MyFeedFilterView.swift
//  WSSiOS
//
//  Created by 이윤학 on 5/19/24.
//

import UIKit

import SnapKit
import Then

final class WSSFilterButton: UIButton {
    
    //MARK: - Properties
    
    private let buttonHeight: CGFloat = 33
    
    //MARK: - Components
    
    private let filterLabel = UILabel()
    private let filterImageView = UIImageView()
    
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
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = buttonHeight / 2
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.wssGray80.cgColor
        }
        
        filterLabel.do {
            $0.textColor = .wssGray300
        }
        
        filterImageView.do {
            $0.image = .icDropdownfill
        }
    }
    
    private func setHierarchy() {
        addSubview(filterLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(buttonHeight)
        }
    }
    
    //MARK: - Custom Method
    
    func setButtonText(_ text: String) {
        filterLabel.do {
            $0.applyWSSFont(.body4, with: text)
        }
    }
    
    func setImageHidden(isHidden: Bool) {
        if isHidden {
            filterLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.horizontalEdges.equalToSuperview().inset(13)
            }
        } else {
            self.addSubview(filterImageView)
            
            filterLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(13)
            }
            filterImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(filterLabel.snp.trailing).offset(4)
                $0.trailing.equalToSuperview().inset(13)
                $0.size.equalTo(14)
            }
        }
    }
    
    func updateButton(isSelected: Bool) {
        self.do {
            $0.layer.borderColor = isSelected ? UIColor.wssBlack.cgColor : UIColor.wssGray80.cgColor
            $0.backgroundColor = isSelected ? .wssBlack : .wssWhite
        }
        
        filterLabel.textColor = isSelected ? .wssWhite : .wssGray300
    }
}

