//
//  NovelSummaryView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalNovelSummaryView: UIView {

    // MARK: - Components
    
    private let novelSummaryStackView = UIStackView()
    
    private let plotTitleLabel = WSSSectionTitleView()
    private let plotLabel = UILabel()
    
    private let genreTitleLabel = WSSSectionTitleView()
    private let genreLabel = UILabel()
    
    private let platformTitleLabel = WSSSectionTitleView()
    let platformCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssGray50
        }
        novelSummaryStackView.do {
            $0.axis = .vertical
            $0.spacing = 35
            $0.alignment = .fill
        }
        
        plotTitleLabel.do {
            $0.setText(StringLiterals.Register.Normal.SectionTitle.plot)
        }
        
        genreTitleLabel.do {
            $0.setText(StringLiterals.Register.Normal.SectionTitle.genre)
        }
        
        platformTitleLabel.do {
            $0.setText(StringLiterals.Register.Normal.SectionTitle.platform)
        }
        
        platformCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
        }
    }
    
    private func setHieararchy() {
        self.addSubview(novelSummaryStackView)
        novelSummaryStackView.addArrangedSubviews(plotTitleLabel,
                                                  plotLabel,
                                                  genreTitleLabel,
                                                  genreLabel,
                                                  platformTitleLabel,
                                                  platformCollectionView)
    }
    
    private func setLayout() {
        novelSummaryStackView.do {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().inset(32)
                $0.bottom.equalToSuperview().inset(100)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
            
            $0.setCustomSpacing(10, after: plotTitleLabel)
            $0.setCustomSpacing(10, after: genreTitleLabel)
            $0.setCustomSpacing(10, after: platformTitleLabel)
        }
        
        platformCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    // MARK: - Data
    
    func bindData(plot: String?, genre: String?, platforms: [UserNovelPlatform]) {
        setText(of: plotLabel, text: plot)
        setText(of: genreLabel, text: genre)
    }
    
    // MARK: - Custom Method
    
    func setText(of label: UILabel, text: String?) {
        label.text = text
        bodyStyle(of: label)
    }
    
    func updateCollectionViewHeight(height: CGFloat) {
        platformCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    func hiddenPlatformView(_ count: Int) {
        if count == 0 {
            platformTitleLabel.isHidden = true
            platformCollectionView.isHidden = true
        }
    }
    
    /// 각 Section의 본문 텍스트 스타일
    private func bodyStyle(of label: UILabel) {
        label.do {
            $0.makeAttribute(with: label.text)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
            $0.numberOfLines = 0
            $0.textColor = .wssGray300
        }
    }
}
