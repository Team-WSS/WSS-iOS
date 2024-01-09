//
//  WSSMainButton.swift
//  WSSiOS
//
//  Created by 신지원 on 1/9/24.
//

import UIKit

class WSSMainButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        titleLabel?.font = .Title1
        setTitleColor(.White, for: .normal)
        backgroundColor = .Primary100
        layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
