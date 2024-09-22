//
//  NovelDetailNovelInfoView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderNovelInfoView: UIView {
    
    //MARK: - Properties
    
    private let titleLineLimit = 3
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let reviewStack = UIStackView()
    
    private let interestCount = NovelDetailHeaderReviewSummaryElementView()
    private let rating = NovelDetailHeaderReviewSummaryElementView()
    private let feedCount = NovelDetailHeaderReviewSummaryElementView()
    
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
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 6
            $0.alignment = .center
            
            setTitleLabelText(with: StringLiterals.NovelDetail.Header.Loading.novelTitle)
            
            setInfoLabelText(with: "\(StringLiterals.NovelDetail.Header.Loading.novelGenre) · \(StringLiterals.NovelDetail.Header.Loading.novelAuthor)")
            
            reviewStack.do {
                $0.axis = .horizontal
                $0.spacing = 20
                $0.alignment = .center
                
                interestCount.do {
                    $0.setImage(.icCountInterest)
                    $0.setText(with: StringLiterals.NovelDetail.Header.Loading.novelInterestCount)
                }
                
                rating.do {
                    $0.setImage(.icCountRating)
                    $0.setText(with: StringLiterals.NovelDetail.Header.Loading.novelRatingCount)
                }
                
                feedCount.do {
                    $0.setImage(.icCountFeed)
                    $0.setText(with: StringLiterals.NovelDetail.Header.Loading.novelFeedCount)
                }
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(titleLabel,
                                      infoLabel,
                                      reviewStack)
        reviewStack.addArrangedSubviews(interestCount,
                                        rating,
                                        feedCount)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderResult) {
        let novelCompletedStatusText = data.isNovelCompleted ? StringLiterals.NovelDetail.Header.complete
                                                             : StringLiterals.NovelDetail.Header.inSeries
        
        setTitleLabelText(with: data.novelTitle)
        setInfoLabelText(with: "\(data.novelGenres)\(novelCompletedStatusText)\(data.author)")
        interestCount.setText(with: "\(data.interestCount)")
        rating.setText(with: "\(data.novelRating) (\(data.novelRatingCount))")
        feedCount.setText(with: "\(data.feedCount)")
    }
    
    //MARK: - Custom Method
    
    private func setTitleLabelText(with text: String) {
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: text)
            $0.textColor = .wssBlack
            $0.textAlignment = .center
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
            $0.numberOfLines = titleLineLimit
        }
    }
    
    private func setInfoLabelText(with text: String) {
        infoLabel.do {
            $0.applyWSSFont(.body3, with: text)
            $0.textColor = .wssGray200
            $0.textAlignment = .center
            $0.numberOfLines = 1
        }
    }
}
