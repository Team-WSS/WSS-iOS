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
    
    let progressView = OnboardingProgressView()
    let nickNameView = OnboardingNicknameView()
    
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
        self.backgroundColor = .wssWhite
    }
    
    private func setHierarchy() {
        self.addSubviews(progressView,
                        nickNameView)
    }
    
    private func setLayout() {
        progressView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(3)
            $0.horizontalEdges.equalToSuperview()
        }
        
        nickNameView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
}

