//
//  OnboardingGenreButtonView.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/1/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingGenreButtonView: UIView {
    
    //MARK: - Properties
    
    let genre: NewNovelGenre
    
    private let buttonHeight: CGFloat = 83
    
    //MARK: - Components
    
    private let genreButton = UIButton()
    private let genreImageView = UIImageView()
    private let checkImageView = UIImageView()
    private let genreLabel = UILabel()
    
    //MARK: - Life Cycle
    
    init(genre: NewNovelGenre) {
        self.genre = genre
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        genreButton.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = buttonHeight/2
            $0.layer.borderColor = UIColor.wssPrimary100.cgColor
            
            genreImageView.do {
                $0.image = genre.image
                $0.contentMode = .scaleAspectFit
                $0.isUserInteractionEnabled = false
            }
            
            checkImageView.do {
                $0.image = .icOnboardingCheck
                $0.contentMode = .scaleAspectFit
                $0.isUserInteractionEnabled = false
                $0.isHidden = true
            }
        }
        
        genreLabel.do {
            $0.applyWSSFont(.title3, with: genre.withKorean)
            $0.textColor = .wssGray300
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(genreButton,
                         genreLabel)
        genreButton.addSubviews(genreImageView,
                                checkImageView)
    }
    
    private func setLayout() {
        genreButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.size.equalTo(buttonHeight)
            
            genreImageView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(44)
            }
            
            checkImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.size.equalTo(44)
            }
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(genreButton.snp.bottom).inset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    func updateButton(selectedGenres: [NewNovelGenre]) {
        let isSelected = selectedGenres.contains(genre)
        
        genreButton.do {
            $0.backgroundColor = isSelected ? .wssPrimary50 : .wssGray50
            $0.layer.borderWidth = isSelected ? 2 : 0
        }
        
        checkImageView.isHidden = !isSelected
        genreImageView.isHidden = isSelected
    }
}
