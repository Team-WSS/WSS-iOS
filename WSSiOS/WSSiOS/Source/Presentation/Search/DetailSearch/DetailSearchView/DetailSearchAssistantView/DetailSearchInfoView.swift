//
//  DetailSearchInfoView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchInfoView: UIView {
    
    //MARK: - UI Components
    
    /// 장르
    private let genreTItleLabel = UILabel()
    
    let genreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    /// 연재상태
    private let statusTitleLabel = UILabel()
    
    private let statusStackView = UIStackView()
    private let ingStatusKeywordView = KeywordViewManager.shared.box()
    private let finishedStatusKeywordView = KeywordViewManager.shared.box()

    /// 평점
    private let ratingTitleLabel = UILabel()
    
    private let ratingTopStackView = UIStackView()
    private let ratingBottomStackView = UIStackView()
    
    private let aboveThreePointFiveKeywordView = KeywordViewManager.shared.box()
    private let aboveFourPointZeroKeywordView = KeywordViewManager.shared.box()
    private let aboveFourPointFiveKeywordView = KeywordViewManager.shared.box()
    private let aboveFourPointEightKeywordView = KeywordViewManager.shared.box()

    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        genreTItleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.DetailSearch.genre)
            $0.textColor = .wssBlack
        }
        
        genreCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 14
            layout.minimumInteritemSpacing = 6

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
        }
        
        statusTitleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.DetailSearch.serialStatus)
            $0.textColor = .wssBlack
        }
        
        statusStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.distribution = .fillEqually
            
            ingStatusKeywordView.do {
                $0.setText(StringLiterals.DetailSearch.statusIng)
                $0.updateColor(true)
            }
            
            finishedStatusKeywordView.do {
                $0.setText(StringLiterals.DetailSearch.statusFinished)
            }
        }
        
        ratingTitleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.DetailSearch.rating)
            $0.textColor = .wssBlack
        }
        
        ratingTopStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.distribution = .fillEqually
            
            aboveThreePointFiveKeywordView.do {
                $0.setText(StringLiterals.DetailSearch.ratingaboveThreePointFive)
            }
            
            aboveFourPointZeroKeywordView.do {
                $0.setText(StringLiterals.DetailSearch.ratingaboveFourPointZero)
            }
        }
        
        ratingBottomStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.distribution = .fillEqually
            
            aboveFourPointFiveKeywordView.do {
                $0.setText(StringLiterals.DetailSearch.ratingaboveFourPointFive)
            }
            
            aboveFourPointEightKeywordView.do {
                $0.setText(StringLiterals.DetailSearch.ratingaboveFourPointEight)
            }
        }
        
        ratingBottomStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.distribution = .fillEqually
        }
    }
    
    private func setHierarchy() {
        statusStackView.addArrangedSubviews(ingStatusKeywordView,
                                            finishedStatusKeywordView)
        
        ratingTopStackView.addArrangedSubviews(aboveThreePointFiveKeywordView,
                                               aboveFourPointZeroKeywordView)
        
        ratingBottomStackView.addArrangedSubviews(aboveFourPointFiveKeywordView,
                                                  aboveFourPointEightKeywordView)
        self.addSubviews(genreTItleLabel,
                         genreCollectionView,
                         statusTitleLabel,
                         statusStackView,
                         ratingTitleLabel, 
                         ratingTopStackView,
                         ratingBottomStackView)
    }
    
    private func setLayout() {
        genreTItleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        genreCollectionView.snp.makeConstraints {
            $0.top.equalTo(genreTItleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(88)
        }
        
        statusTitleLabel.snp.makeConstraints {
            $0.top.equalTo(genreCollectionView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(20)
        }
        
        statusStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(statusTitleLabel.snp.bottom).offset(16)
        }
        
        ratingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(statusStackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(20)
        }
        
        ratingTopStackView.snp.makeConstraints {
            $0.top.equalTo(ratingTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        ratingBottomStackView.snp.makeConstraints {
            $0.top.equalTo(ratingTopStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func updateCollectionViewHeight(height: CGFloat) {
        genreCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
