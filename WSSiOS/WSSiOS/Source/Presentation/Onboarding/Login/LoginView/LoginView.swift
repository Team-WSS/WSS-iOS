//
//  LoginView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class LoginView: UIView {
    
    //MARK: - Components
   
    let backgroundImgaeView = UIImageView()
    
    let platformButtonStackView = LoginPlatformButtonStackView()
    let skipButton = LoginSkipButton()
    
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
        self.backgroundColor = .white
        
        backgroundImgaeView.do {
            $0.image = .imgLoginBackground
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
    }
    
    private func setHierarchy() {
        self.addSubview(backgroundImgaeView)
        backgroundImgaeView.addSubviews(platformButtonStackView,
                                        skipButton)
    }
    
    private func setLayout() {
        backgroundImgaeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        platformButtonStackView.snp.makeConstraints {
            $0.bottom.equalTo(skipButton.snp.top).offset(-34)
            $0.centerX.equalToSuperview()
        }
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
