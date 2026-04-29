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
    let completedStatusButtons = PublicationStatus.allCases.map { DetailSearchCompletedStatusButton(status: $0) }
    
    /// 평점
    private let ratingTitleLabel = UILabel()
    let ratingSlider = WSSRangeSlider()
    private let ratingValueLabel = UILabel()
    private let ratingMinLabelBackgroundView = UIView()
    private let ratingMinLabel = UILabel()
    private let ratingMaxLabelBackgroundView = UIView()
    private let ratingMaxLabel = UILabel()
    
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

        ratingValueLabel.do {
            $0.applyWSSFont(.title2, with: "0.0 ~ 5.0")
            $0.textColor = .wssPrimary100
        }

        ratingSlider.do {
            $0.minimumValue = 0.0
            $0.maximumValue = 5.0
            $0.step = 0.5
            $0.setValues(lower: 0.0, upper: 5.0)
        }

        ratingMinLabel.do {
            $0.applyWSSFont(.body2, with: "0.0")
            $0.textColor = .wssPrimary100
        }

        [ratingMinLabelBackgroundView,
         ratingMaxLabelBackgroundView].forEach {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 8
        }

        ratingMaxLabel.do {
            $0.applyWSSFont(.body2, with: "5.0")
            $0.textColor = .wssPrimary100
        }
    }
    
    private func setHierarchy() {
        completedStatusButtons.forEach { statusStackView.addArrangedSubview($0) }
        ratingMinLabelBackgroundView.addSubview(ratingMinLabel)
        ratingMaxLabelBackgroundView.addSubview(ratingMaxLabel)
        
        self.addSubviews(genreTitleLabel,
                         genreCollectionView,
                         statusTitleLabel,
                         statusStackView,
                         ratingTitleLabel,
                         ratingValueLabel,
                         ratingMinLabelBackgroundView,
                         ratingSlider,
                         ratingMaxLabelBackgroundView)
    }
    
    private func setLayout() {
        genreTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        genreCollectionView.snp.makeConstraints {
            $0.top.equalTo(genreTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(88)
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

        ratingValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(ratingTitleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }

        ratingMinLabelBackgroundView.snp.makeConstraints {
            $0.top.equalTo(ratingTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(50)
            $0.height.equalTo(38)
            
            ratingMinLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }

        ratingSlider.snp.makeConstraints {
            $0.centerY.equalTo(ratingMinLabel)
            $0.leading.equalTo(ratingMinLabelBackgroundView.snp.trailing).offset(17)
            $0.trailing.equalTo(ratingMaxLabelBackgroundView.snp.leading).offset(-17)
            $0.height.equalTo(16)
        }

        ratingMaxLabelBackgroundView.snp.makeConstraints {
            $0.top.equalTo(ratingMinLabelBackgroundView.snp.top)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(50)
            $0.height.equalTo(38)
            
            ratingMaxLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    func updateCompletedKeyword(_ selectedCompletedStatus: PublicationStatus?) {
        completedStatusButtons.forEach {
            $0.updateButton(selectedCompletedStatus: selectedCompletedStatus)
        }
    }
    
    func resetAllStates() {
        genreCollectionView.indexPathsForSelectedItems?.forEach { indexPath in
            genreCollectionView.deselectItem(at: indexPath, animated: false)
        }
    }

    func updateRatingLabels(lower: CGFloat, upper: CGFloat) {
        let lowerText = String(format: "%.1f", lower)
        let upperText = String(format: "%.1f", upper)
        ratingMinLabel.applyWSSFont(.body2, with: lowerText)
        ratingMaxLabel.applyWSSFont(.body2, with: upperText)
        ratingValueLabel.applyWSSFont(.body2, with: "\(lowerText) ~ \(upperText)")
        ratingValueLabel.textColor = .wssPrimary100
    }
}
