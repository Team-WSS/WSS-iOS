//
//  MyPageSettingView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class MyPageSettingView: UIView {
    
    //MARK: - Components
  
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .wssPrimary20
        
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
    
    //MARK: - Data
    
}

