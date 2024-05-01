//
//  WSSDropdownTableViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 4/1/24.
//

import UIKit

import SnapKit
import Then

final class WSSDropdownTableViewCell: UITableViewCell {

    //MARK: - Components
    
    private let cellLabel = UILabel()
    private let divderView = UIView()
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI

    private func setUI() {
        cellLabel.do {
            $0.font = .Body2
        }
        
        divderView.do {
            $0.backgroundColor = .Gray50
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(divderView,
                         cellLabel)
    }
    
    private func setLayout() {
        divderView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.height.equalTo(0.7)
        }
        
        cellLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Data
    
    func bindText(text: String, color: UIColor) {
        cellLabel.text = text
        cellLabel.textColor = color
    }
}
