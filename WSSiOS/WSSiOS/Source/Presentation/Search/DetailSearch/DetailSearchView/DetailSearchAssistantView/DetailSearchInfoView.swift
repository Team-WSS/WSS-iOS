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
    private let genreTitleLabel = UILabel()
    
    let genreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    /// 연재상태
    private let statusTitleLabel = UILabel()
    
    private let statusStackView = UIStackView()
    let completedStatusButtons = CompletedStatus.allCases.map { DetailSearchCompletedStatusButton(status: $0) }
    
    /// 평점
    private let ratingTitleLabel = UILabel()
    
    private let ratingTopStackView = UIStackView()
    private let ratingBottomStackView = UIStackView()
    
    let novelRatingStatusButtons = NovelRatingStatus.allCases.map { DetailSearchNovelRatingStatusButton(status: $0) }
    
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
        genreTitleLabel.do {
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
            $0.allowsMultipleSelection = true
        }
        
        statusTitleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.DetailSearch.serialStatus)
            $0.textColor = .wssBlack
        }
        
        statusStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.distribution = .fillEqually
        }
        
        ratingTitleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.DetailSearch.rating)
            $0.textColor = .wssBlack
        }
        
        ratingTopStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.distribution = .fillEqually
        }
        
        ratingBottomStackView.do {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.distribution = .fillEqually
        }
    }
    
    private func setHierarchy() {
        completedStatusButtons.forEach { statusStackView.addArrangedSubview($0) }
        
        let topRowButtons = Array(novelRatingStatusButtons.prefix(2))
        let bottomRowButtons = Array(novelRatingStatusButtons.suffix(2))
        
        topRowButtons.forEach { ratingTopStackView.addArrangedSubview($0) }
        bottomRowButtons.forEach { ratingBottomStackView.addArrangedSubview($0) }
        
        self.addSubviews(genreTitleLabel,
                         genreCollectionView,
                         statusTitleLabel,
                         statusStackView,
                         ratingTitleLabel,
                         ratingTopStackView,
                         ratingBottomStackView)
    }
    
    private func setLayout() {
        genreTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        genreCollectionView.snp.makeConstraints {
            $0.top.equalTo(genreTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(84)
        }
        
        statusTitleLabel.snp.makeConstraints {
            $0.top.equalTo(genreCollectionView.snp.bottom).offset(42)
            $0.leading.equalToSuperview().inset(20)
        }
        
        statusStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(statusTitleLabel.snp.bottom).offset(16)
            $0.height.equalTo(43)
        }
        
        ratingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(statusStackView.snp.bottom).offset(42)
            $0.leading.equalToSuperview().inset(20)
        }
        
        ratingTopStackView.snp.makeConstraints {
            $0.top.equalTo(ratingTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(43)
        }
        
        ratingBottomStackView.snp.makeConstraints {
            $0.top.equalTo(ratingTopStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(43)
        }
    }
    
    func updateCompletedKeyword(_ selectedCompletedStatus: CompletedStatus?) {
        completedStatusButtons.forEach {
            $0.updateButton(selectedCompletedStatus: selectedCompletedStatus)
        }
    }
    
    func updateNovelRatingKeyword(_ selectedNovelRatingStatus: NovelRatingStatus?) {
        novelRatingStatusButtons.forEach {
            $0.updateButton(selectedNovelRatingStatus: selectedNovelRatingStatus)
        }
    }
    
    func resetAllStates() {
        genreCollectionView.indexPathsForSelectedItems?.forEach { indexPath in
            genreCollectionView.deselectItem(at: indexPath, animated: false)
        }
        completedStatusButtons.forEach { $0.updateButton(selectedCompletedStatus: nil) }
        novelRatingStatusButtons.forEach { $0.updateButton(selectedNovelRatingStatus: nil) }
    }
}
