//
//  OnboardingView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingView: UIView {
    
    //MARK: - Components
    
    let nickNameView = OnboardingNickNameView()
    
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
       
    }
    
    private func setHierarchy() {
        self.addSubview(nickNameView)
    }
    
    private func setLayout() {
        nickNameView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

