//
//  HomeRealTimePopularFeedView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/21/24.
//

import UIKit

import SnapKit
import Then

final class HomeRealTimePopularFeedView: UIView {
    
    //MARK: - UI Components
    
    private let contentStackView = UIStackView()
    private let novelTitleLabel = UILabel()
    private let feedContentLabel = UILabel()
    private let novelImageView = UIImageView()
    private let novelGenreImageView = UIImageView()
    
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
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        novelTitleLabel.do {
            $0.textColor = .wssBlack
        }
        
        feedContentLabel.do {
            $0.textColor = .wssBlack
        }
        
        novelImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = .imgLoadingThumbnail
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        novelGenreImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .icGenreBackground
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(contentStackView,
                         novelImageView)
        contentStackView.addArrangedSubviews(novelTitleLabel,
                                             feedContentLabel)
        novelImageView.addSubview(novelGenreImageView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(90)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalToSuperview()
        }
        
        novelImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(contentStackView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(64)
        }
        
        novelGenreImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.size.equalTo(30)
        }
    }
    
    func bindData(data: RealtimePopularFeed) {
        novelTitleLabel.do {
            $0.applyWSSFont(.title3,
                            with: data.novelTitle)
            $0.lineBreakMode = .byTruncatingTail
        }
        
        feedContentLabel.do {
            if data.isSpoiler {
                $0.applyWSSFont(.body5, with: StringLiterals.Home.RealTimePopular.spoiler)
                $0.textColor = .wssSecondary100
            }
            else {
                $0.applyWSSFont(.body5, with: data.feedContent)
                $0.textColor = .wssBlack
            }
            $0.numberOfLines = 3
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        novelImageView.do {
            $0.kfSetImage(url: data.novelImage)
        }
        
        novelGenreImageView.do {
            $0.image = NovelGenre.allCases
                .first(where: { $0.rawValue == data.novelGenre })?
                .markImage
        }
    }
}
