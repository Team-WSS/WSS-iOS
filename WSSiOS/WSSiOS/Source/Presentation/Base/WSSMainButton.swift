//
//  WSSMainButton.swift
//  WSSiOS
//
//  Created by 신지원 on 1/9/24.
//

import UIKit

import SnapKit

class WSSMainButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, selfY: Bool) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        titleLabel?.font = .Title1
        setTitleColor(.White, for: .normal)
        backgroundColor = .Primary100
        layer.cornerRadius = 12
        
        self.snp.makeConstraints() {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(53)
            
            if !selfY {
                $0.bottom.equalTo(super.safeAreaInsets.bottom)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
