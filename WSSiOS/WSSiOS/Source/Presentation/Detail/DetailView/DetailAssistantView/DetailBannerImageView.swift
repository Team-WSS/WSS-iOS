//
//  DetailBannerImageView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import UIKit

import SnapKit
import Then

final class DetailBannerImageView: UIView {
    
    //MARK: - Components
    
    
    
    //MARK: - Life Cycle
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
       
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelBasicData) {
       
    }
}
