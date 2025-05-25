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
    
    private let stackView = UIStackView()
    private let cellLabel = UILabel()
    private let cellDescriptionLabel = UILabel()
    
    private let cellIconImageView = UIImageView(image: .icNavigateRight)
    
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
        self.do{
            $0.backgroundColor = .wssWhite
            $0.selectionStyle = .none
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .leading
        }
        
        cellLabel.do {
            $0.textColor = .wssBlack
            $0.font = .Body2
        }
        
        cellDescriptionLabel.do {
            $0.textColor = .wssGray200
            $0.font = .Body3
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(stackView,
                         cellIconImageView)
        stackView.addArrangedSubviews(cellLabel,
                                      cellDescriptionLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
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
        let isEmptyEmail = (title == "")
        if !isEmptyEmail {
            cellDescriptionLabel.applyWSSFont(.body3, with: title)
            cellDescriptionLabel.isHidden = false
        }
        
        cellIconImageView.isHidden = true
    }
}
