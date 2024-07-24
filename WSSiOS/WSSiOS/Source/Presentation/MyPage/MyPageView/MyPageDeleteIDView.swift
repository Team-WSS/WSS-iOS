//
//  MyPageDeleteIDView.swift
//  WSSiOS
//
//  Created by 신지원 on 7/24/24.
//

import UIKit

import SnapKit
import Then

final class MyPageDeleteIDView: UIView {
    
    //MARK: - Components
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
  
    lazy var completeButton = UIButton()
    
    //In NavigationBar
    lazy var backButton = UIButton()
    
    // MARK: - Life Cycle
    
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
        
        completeButton.do {
            $0.backgroundColor = .wssGray70
            $0.layer.cornerRadius = 14
            $0.setTitle(StringLiterals.MyPage.DeleteIDWarning.buttonTitle, for: .normal)
            $0.setTitleColor(.wssWhite, for: .normal)
            $0.titleLabel?.font = .Title1
            $0.isEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews(completeButton)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(53)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
   
}


