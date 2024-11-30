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
    
    private let checkImageView = UIImageView()
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
            $0.isUserInteractionEnabled = true
        }
        
        checkImageView.do {
            $0.image = .checkDefault
        }
        
        titleLabel.do {
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        contentView.addSubviews(checkImageView,
                                titleLabel)
    }
    
    private func setLayout() {
        checkImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkImageView.snp.trailing).offset(8)
        }
    }
    
    //MARK: - Custom Method
    
    func isSelected(isSelected: Bool) {
        checkImageView.image = isSelected ? .checkSelected : .checkDefault
    }
    
    //MARK: - Data
    
    func bindData(text: String) {
        titleLabel.applyWSSFont(.body2, with: text)
    }
}

