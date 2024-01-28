//
//  MyPageSettingCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class MyPageSettingCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "MyPageSettingCollectionViewCell"
    
    //MARK: - Components
    
    let myPageSettingCellLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .White
        
        myPageSettingCellLabel.do {
            $0.textColor = .Black
            $0.font = .Body1
        }
    }
    
    private func setHierachy() {
        self.addSubviews(myPageSettingCellLabel)
    }

    private func setLayout() {
        myPageSettingCellLabel.snp.makeConstraints() {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
