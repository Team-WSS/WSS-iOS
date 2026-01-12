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
    let skipButton = UIButton()
    let progressView = OnboardingProgressView()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let nickNameView = OnboardingNicknameView()
    let birthGenderView = OnboardingBirthGenderView()
    let genrePreferenceView = OnboardingGenrePreferenceView()
    let networkErrrorView = WSSNetworkErrorView()
    
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
        
        skipButton.do {
            $0.setTitle(StringLiterals.Onboarding.GenrePreference.skipButton,
                        for: .normal)
            $0.titleLabel?.applyWSSFont(.body2,
                                        with: StringLiterals.Onboarding.GenrePreference.skipButton)
            $0.setTitleColor(.wssGray300, for: .normal)
        }
        
        scrollView.do {
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.isScrollEnabled = false
        }
        
        networkErrrorView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(progressView,
                         scrollView,
                         networkErrrorView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(nickNameView,
                                birthGenderView,
                                genrePreferenceView)
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
        
        networkErrrorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width * 3)
        }
        
        nickNameView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        birthGenderView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(nickNameView.snp.trailing)
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        genrePreferenceView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(birthGenderView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
    }
    
    //MARK: - Custom Method
    
    func showNetworkErrorView() {
        networkErrrorView.isHidden = false
    }
}
