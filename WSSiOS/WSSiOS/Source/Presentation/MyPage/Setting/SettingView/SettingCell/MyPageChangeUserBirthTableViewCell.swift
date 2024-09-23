//
//  MyPageChangeUserBirthTableViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 9/23/24.
//

import UIKit

import SnapKit
import Then

final class MyPageChangeUserBirthTableViewCell: UITableViewCell {
    
    //MARK: - Components
    
    private let birthLabel = UILabel()
    private let checkImageView = UIImageView()
    
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
        self.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 12
        }
        
        birthLabel.do {
            $0.textColor = .wssGray200
        }
        
        checkImageView.do {
            $0.image = .icCheck
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(birthLabel,
                         checkImageView)
    }
    
    private func setLayout() {
        birthLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.trailing.equalTo(birthLabel.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(22)
        }
    }
    
    //MARK: - Data
    
    func bindYear(year: Int) {
        birthLabel.applyWSSFont(.body2, with: String(describing: year))
    }
    
    func highlightedCell(isHighlighted: Bool) {
        self.backgroundColor = isHighlighted ? .wssPrimary20 : .wssWhite
        birthLabel.textColor = isHighlighted ? .wssBlack : .wssGray200
        checkImageView.isHidden = isHighlighted ? false : true
    }
}
