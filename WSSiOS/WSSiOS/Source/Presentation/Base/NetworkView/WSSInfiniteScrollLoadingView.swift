//
//  WSSInfiniteScrollLoadingView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 11/27/24.
//

import UIKit

import SnapKit
import Then

final class WSSInfiniteScrollLoadingView: UIView {
    
    // MARK: - UI Components
    
    private let loadingLottieView = Lottie.loading
    
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
        
        loadingLottieView.do {
            $0.loopMode = .loop
            $0.animationSpeed = 1.3
            $0.play()
        }
    }
    
    private func setHierarchy() {
        self.addSubview(loadingLottieView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(105)
        }
        
        loadingLottieView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
    }
}
