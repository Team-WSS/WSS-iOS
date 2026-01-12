//
//  LoginPlatformButton.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class LoginPlatformButton: UIButton {
    
    //MARK: - Properties
    
    let platformImage: UIImage
    
    //MARK: - Components
    
    let platformImageView = UIImageView()
    
    //MARK: - Life Cycle
    
    init(_ platformImage: UIImage) {
        self.platformImage = platformImage
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        platformImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = platformImage
        }
    }
    
    private func setHierarchy() {
        self.addSubview(platformImageView)
    }
    
    private func setLayout() {
        platformImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(52)
        }
    }
}
