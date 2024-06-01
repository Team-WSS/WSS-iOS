//
//  MyPageView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class MyPageView: UIView {
    
    //MARK: - Components
    
    private let headerView = MyPageProfileHeaderView()
    
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
       
    }
    
    private func setHierarchy() {
        addSubview(headerView)
    }
    
    private func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
}
