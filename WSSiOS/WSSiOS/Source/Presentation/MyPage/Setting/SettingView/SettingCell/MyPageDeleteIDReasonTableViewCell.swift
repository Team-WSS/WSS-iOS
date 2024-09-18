//
//  MyPageDeleteIDReasonTableViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import SnapKit
import Then

final class MyPageDeleteIDReasonTableViewCell: UITableViewCell {
    
    //MARK: - Components
    
    private let checkButton = UIButton()
    private let titleLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        contentView.do {
            $0.backgroundColor = .wssWhite
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = false
        }
        
        checkButton.do {
            $0.setImage(.checkDefault, for: .normal)
            $0.isUserInteractionEnabled = true
        }
        
        titleLabel.do {
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        contentView.addSubviews(checkButton,
                                titleLabel)
    }
    
    private func setLayout() {
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkButton.snp.trailing).offset(8)
        }
    }
    
    //MARK: - Custom Method
    
    func isSelected(isSelected: Bool) {
        checkButton.setImage( isSelected ? .checkSelected : .checkDefault , for: .normal)
    }
    
    //MARK: - Data
    
    func bindData(text: String) {
        titleLabel.applyWSSFont(.body2, with: text)
    }
}

