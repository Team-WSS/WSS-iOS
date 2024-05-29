//
//  MyPageChangeProfileButtonView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/29/24.
//

import UIKit

import SnapKit
import Then

final class MyPageUserImageChangeButtonView: UIView {
    
    //MARK: - Components
    
    private let pencilImageView = UIImageView(image: .pencil)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setHierarchy() {
        addSubview(pencilImageView)
    }
    
    private func setLayout() {
        pencilImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(20)
        }
    }
}


