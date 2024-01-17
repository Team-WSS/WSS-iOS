//
//  MyPageSettingCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 1/11/24.
//

import UIKit

final class MyPageSettingCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "MyPageSettingCollectionViewCell"
    
    //MARK: - UI Components
    
    let myPageSettingCellButton = UIButton()
    
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
    
    //MARK: - Set UI
    
    private func setUI() {
        self.backgroundColor = .White
        
        myPageSettingCellButton.do {
            $0.setTitleColor(.Black, for: .normal)
            $0.titleLabel?.font = .Body1
        }
    }
    
    //MARK: - Set Hierachy
    
    private func setHierachy() {
        self.addSubviews(myPageSettingCellButton)
    }
    
    //MARK: - Set Layout
    
    private func setLayout() {
        myPageSettingCellButton.snp.makeConstraints() {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
