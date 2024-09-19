//
//  LoginPlatformButtonStackView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class LoginPlatformButtonStackView: UIView {
    
    //MARK: - Components
    
    let stackView = UIStackView()
    
    let kakaoLoginButton = LoginPlatformButton(.imgLoginButtonKakao)
    let naverLoginButton = LoginPlatformButton(.imgLoginButtonNaver)
    let appleLoginButton = LoginPlatformButton(.imgLoginButtonApple)
    
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
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 13
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(kakaoLoginButton,
                                      naverLoginButton,
                                      appleLoginButton)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }       
    }
}
