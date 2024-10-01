//
//  OnboardingGenrePreferenceView.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/1/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingGenrePreferenceView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let skipButton = UIButton()
    
    let genreButtons: [OnboardingGenreButtonView] = NewNovelGenre.onboardingGenres
        .map { OnboardingGenreButtonView(genre: $0) }
    
    let totalGenreStackView = UIStackView()
    let genreLineStackViews = [UIStackView(), UIStackView(), UIStackView()]
    
    let bottomButton = OnboardingBottomButtonView()
    
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
        
        skipButton.do {
            $0.setTitle(StringLiterals.Onboarding.GenrePreference.skipButton,
                        for: .normal)
            $0.titleLabel?.applyWSSFont(.body2, with: StringLiterals.Onboarding.GenrePreference.skipButton)
            $0.setTitleColor(.wssGray300, for: .normal)
        }
        
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.Onboarding.GenrePreference.title)
            $0.textColor = .wssBlack
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Onboarding.GenrePreference.description)
            $0.textColor = .wssGray200
        }
        
        totalGenreStackView.do {
            $0.axis = .vertical
            $0.spacing = 25
        }
        
        genreLineStackViews.forEach {
            $0.do {
                $0.axis = .horizontal
                $0.spacing = 24
            }
        }
        
        bottomButton.do {
            $0.setText(text: StringLiterals.Onboarding.GenrePreference.completeButton)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         descriptionLabel,
                         totalGenreStackView,
                         bottomButton)
        
        genreLineStackViews.forEach {
            totalGenreStackView.addArrangedSubview($0)
        }
        
        genreLineStackViews.enumerated().forEach { (index, stackView) in
            let startIndex = index*3
            genreButtons[startIndex...(startIndex+2)].forEach {
                genreLineStackViews[index].addArrangedSubview($0)
            }
        }
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
        }
        
        totalGenreStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(UIScreen.isSE ? 20 : 50)
            $0.centerX.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
        }
    }
    
    // MARK: - Custom Method
    
}

