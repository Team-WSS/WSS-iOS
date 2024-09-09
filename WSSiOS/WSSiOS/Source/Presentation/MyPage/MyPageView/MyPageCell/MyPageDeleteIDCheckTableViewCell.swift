//
//  MyPageDeleteIDCheckTableViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import SnapKit
import Then

final class MyPageDeleteIDCheckTableViewCell: UITableViewCell {
    
    //MARK: - Components
    
    private let checkView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
        checkView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
        }
        
        titleLabel.do {
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubview(checkView)
        checkView.addSubviews(titleLabel,
                              descriptionLabel)
    }
    
    private func setLayout() {
        checkView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(18)
        }
    }
    
    //MARK: - Data
    
    func bindData(title: String, description: String) {
        titleLabel.applyWSSFont(.title2, with: title)
        
        descriptionLabel.do {
            $0.applyWSSFont(.body4, with: description)
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = 0
        }
    }
}
