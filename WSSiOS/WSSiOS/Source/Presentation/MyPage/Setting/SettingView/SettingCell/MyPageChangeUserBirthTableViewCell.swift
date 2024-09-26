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
    
    let birthLabel = UILabel()
    
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
            $0.backgroundColor = .clear
            $0.selectionStyle = .none
        }
        
        birthLabel.do {
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubview(birthLabel)
    }
    
    private func setLayout() {
        birthLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindYear(year: Int) {
        birthLabel.applyWSSFont(.body2, with: String(describing: year))
    }
    
    func highlightedCell(isHighlighted: Bool) {
        birthLabel.textColor = isHighlighted ? .wssBlack : .wssGray200
    }
}
