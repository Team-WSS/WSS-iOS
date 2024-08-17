//
//  WSSDropdownButton.swift
//  WSSiOS
//
//  Created by 신지원 on 4/3/24.
//

import UIKit

import SnapKit
import Then

final class WSSDropdownButton: UIButton { 
    
    // MARK: - UI Components
    
    private let dropdownImageView = UIImageView(image: UIImage(resource: .icDropDownDot))
    
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
    
    //MARK: - UI
    
    private func setHierarchy() {
        addSubview(dropdownImageView)
    }
    
    private func setLayout() {
        dropdownImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
    }
    
    func makeDropdown(dropdownRootView: UIView,
                      dropdownWidth: Double,
                      dropdownData: [String],
                      textColor: UIColor) {
        
        WSSDropdownManager.shared.createDropdown(superView: dropdownRootView,
                                                 dropdownButton: self,
                                                 dropdownWidth: dropdownWidth,
                                                 dropdownData: dropdownData,
                                                 textColor: textColor)
    }
}
