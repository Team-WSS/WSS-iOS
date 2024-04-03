//
//  TestView.swift
//  WSSiOS
//
//  Created by 신지원 on 4/3/24.
//

import UIKit

final class TestView: UIView {
    
    private let dummyData = ["수정하기", "삭제하기"]
    private let dropdownView = WSSDropdown()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .brown
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        dropdownView.makeDropdown(dropdownRootView: self,
                                  dropdownWidth: 190,
                                  dropdownData: dummyData)
    }
    
    private func setHierarchy() {
        addSubview(dropdownView)
    }
    
    private func setLayout() {
        dropdownView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.size.equalTo(38)
        }
    }
}
