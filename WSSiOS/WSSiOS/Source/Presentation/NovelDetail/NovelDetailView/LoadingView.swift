//
//  LoadingView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/24/24.
//

import UIKit

import SnapKit
import Then

final class LoadingView: UIView {
    
    //MARK: - Components
    
    let stackView = UIStackView()
    let loadingLabel = UILabel()
    let descriptionLabel = UILabel()
    
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
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }
        
        loadingLabel.do {
            $0.applyWSSFont(.title2, with: "로딩 중")
            $0.textColor = .wssPrimary100
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: "잠시만 기다려주세요")
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(loadingLabel,
                                      descriptionLabel)
    }
    
    private func setLayout() {
        stackView.do {
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            $0.setCustomSpacing(4, after: loadingLabel)
        }
    }
}

