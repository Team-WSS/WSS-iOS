//
//  WSSLoadingView.swift
//  WSSiOS
//
//  Created by YunhakLee on 11/4/24.
//

import UIKit

import SnapKit
import Then

final class WSSLoadingView: UIView {
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
    private let loadingLottieView = Lottie.loading
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
    
    // MARK: - Custom Method
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }
        
        loadingLottieView.do {
            $0.loopMode = .loop
            $0.animationSpeed = 1.3
            $0.play()
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.Loading.loadingTitle)
            $0.textColor = .wssPrimary100
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Loading.loadingDescription)
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(stackView)
        stackView.addArrangedSubviews(loadingLottieView,
                                      titleLabel,
                                      descriptionLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-32)
            
            stackView.do {
                $0.setCustomSpacing(12, after: loadingLottieView)
                $0.setCustomSpacing(4, after: titleLabel)
            }
        }
        
        loadingLottieView.snp.makeConstraints {
            $0.size.equalTo(50)
        }
    }
}
