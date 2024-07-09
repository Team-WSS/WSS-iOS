//
//  MyPageSettingCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class MyPageSettingTableViewCell: UITableViewCell {
    
    //MARK: - Components
    
    let cellLabel = UILabel()
    let cellDescriptionLabel = UILabel()
    let cellIconImageView = UIImageView(image: .icNavigateRight)
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .wssWhite
        
        cellLabel.do {
            $0.textColor = .wssBlack
            $0.font = .Body2
        }
        
        cellDescriptionLabel.do {
            $0.textColor = .wssGray200
            $0.font = .Body3
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(cellLabel,
                         cellIconImageView)
    }
    
    private func setLayout() {
        cellLabel.snp.makeConstraints() {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        cellIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
    }
    
    //MARK: - Data
    
    func bindData(title: String) {
        cellLabel.applyWSSFont(.body2, with: title)
    }
    
    func bindDescriptionData(title: String) {
        cellDescriptionLabel.applyWSSFont(.body3, with: title)
        
        self.addSubview(cellDescriptionLabel)
        
        cellLabel.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(9.5)
            $0.leading.equalToSuperview().inset(20)
        }
        
        cellDescriptionLabel.snp.makeConstraints() {
            $0.top.equalTo(cellLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
