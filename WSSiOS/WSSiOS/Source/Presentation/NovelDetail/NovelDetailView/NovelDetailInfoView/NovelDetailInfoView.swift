//
//  NovelDetailInfoView.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/23/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoView: UIButton {
    
    //MARK: - Components
    
    private let dummyLabel = UILabel()
    
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
        
        dummyLabel.do {
            $0.applyWSSFont(.headline1, with: "Info View")
            $0.textColor = .wssGray80
        }
    }
    
    private func setHierarchy() {
        self.addSubview(dummyLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(1000)
        }
        
        dummyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
