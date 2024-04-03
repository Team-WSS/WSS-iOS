//
//  WSSDropdownButton.swift
//  WSSiOS
//
//  Created by 신지원 on 4/3/24.
//

import UIKit

import SnapKit
import Then

final class WSSDropdown: UIView { 
    
    // MARK: - UI Components
    
    private let  dropdownImageView = UIImageView(image: UIImage(resource: .icDropDownDot))
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear

        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierarchy() {
        addSubview(dropdownImageView)
    }
    
    private func setLayout() {
        dropdownImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
    }
}
