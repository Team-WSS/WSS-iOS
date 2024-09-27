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
    
    let backButton = UIButton()
    let progressView = OnboardingProgressView()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let nickNameView = OnboardingNicknameView()
    let birthGenderView = OnboardingBirthGenderView()
    
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
        
        backButton.setImage(.icNavigateLeft.withTintColor(.wssBlack),
                            for: .normal)
        
        scrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.isScrollEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(progressView,
                         scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(nickNameView,
                               birthGenderView)
    }
    
    private func setLayout() {
        progressView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(3)
            $0.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalToSuperview()
        }
        
        nickNameView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        birthGenderView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(nickNameView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
    }
}

