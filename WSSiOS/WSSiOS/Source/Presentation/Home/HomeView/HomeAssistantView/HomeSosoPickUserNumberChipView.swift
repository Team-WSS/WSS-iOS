//
//  HomeSosoPickUserNumberChipView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/11/24.
//

import UIKit

final class HomeSosoPickUserNumberChipView: UIView {
    
    //MARK: - UI Components
    
    private let userNumberLabel = UILabel()
    
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
    
    //MARK: - set UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .Gray50
            $0.layer.cornerRadius = 14
        }
        
        userNumberLabel.do {
            $0.text = "5명이 등록"
            $0.font = .Label2
            $0.textColor = .Gray300
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(userNumberLabel)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(userNumberLabel.snp.width).offset(26)
            $0.height.equalTo(userNumberLabel.snp.height).offset(14)
        }
        
        userNumberLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

