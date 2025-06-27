//
//  WSSSortButton.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/26/25.
//

import UIKit

import SnapKit
import Then

final class WSSSortButton: UIButton {
    
    //MARK: - Components
    
    private let sortButtonLabel = UILabel()
    private let sortButtonImageView = UIImageView()
    
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
        self.addSubviews(sortButtonLabel,
                         sortButtonImageView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(33)
        }
        
        sortButtonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        sortButtonLabel.snp.makeConstraints {
            $0.leading.equalTo(sortButtonImageView.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateSortButton(sortType: SortType) {
        sortButtonLabel.applyWSSFont(.body3, with: sortType.text)
    }
}

