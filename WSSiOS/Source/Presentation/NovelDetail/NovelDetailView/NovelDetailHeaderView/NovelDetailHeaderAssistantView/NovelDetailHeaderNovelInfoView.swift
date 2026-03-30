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
    private var currentAuthors: [String] = []

    //MARK: - Callbacks

    var onAuthorTapped: ((String) -> Void)?

    //MARK: - Components

    private let stackView = UIStackView()

    private let titleLabel = UILabel()

    private let infoStack = UIStackView()
    private let infoLabel = UILabel()
    private let authorStackView = UIStackView()
    
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
        authorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
        }

        infoStack.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
        }
        
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
        infoStack.addArrangedSubviews(infoLabel,
                                      authorStackView)
        stackView.addArrangedSubviews(titleLabel,
                                      infoStack,
                                      reviewStack)
        reviewStack.addArrangedSubviews(interestCount,
                                        rating,
                                        feedCount)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        infoStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderEntity) {
        let novelCompletionText = data.isNovelCompleted ? StringLiterals.NovelDetail.Header.complete : StringLiterals.NovelDetail.Header.inSeries
        let novelRatingText = "\(data.novelRating) (\(data.novelRatingCount))"
        
        setTitleLabelText(with: data.novelTitle)
        setInfoLabelText(with: "\(data.novelGenre)  ·  \(novelCompletionText)  ·  ")
        setNovelAuthorText(with: data.novelAuthor)
        interestCount.setText(with: "\(data.interestCount)")
        rating.setText(with: novelRatingText)
        feedCount.setText(with: "\(data.feedCount)")
        print(data)
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
    
    private func setNovelAuthorText(with authors: [String]) {
        currentAuthors = authors
        authorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, author) in authors.enumerated() {
            let label = UILabel()
            label.attributedText = label.makeWSSAttributed(.body3, text: author, underline: true)
            label.textColor = .wssGray200
            label.isUserInteractionEnabled = true
            label.tag = index
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(authorLabelTapped(_:))))
            authorStackView.addArrangedSubview(label)

            if index < authors.count - 1 {
                let separator = UILabel()
                separator.attributedText = separator.makeWSSAttributed(.body3, text: ", ", underline: false)
                separator.textColor = .wssGray200
                authorStackView.addArrangedSubview(separator)
            }
        }
    }

    @objc private func authorLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel,
              label.tag < currentAuthors.count else { return }
        onAuthorTapped?(currentAuthors[label.tag])
    }
}
