//
//  FeedDetailContentView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit

import SnapKit
import Then

final class FeedDetailContentView: UIView {
    
    //MARK: - UI Components
    
    private let contentLabel = UILabel()
    private let linkNovelView = FeedNovelView()
    private let genreLabel = UILabel()
    private let reactView = FeedReactView()
    private let dividerView = UIView()
    
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
        contentLabel.do {
            $0.textColor = .wssBlack
        }
        
        genreLabel.do {
            $0.textColor = .wssGray200
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(contentLabel,
                         linkNovelView,
                         genreLabel,
                         reactView,
                         dividerView)
    }
    
    private func setLayout() {
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        linkNovelView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(linkNovelView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        reactView.snp.makeConstraints {
            $0.top.equalTo(genreLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(reactView.snp.bottom).offset(22)
            $0.height.equalTo(7)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bindData(data: Feed) {
        contentLabel.do {
            $0.applyWSSFont(.body2, with: data.content)
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        linkNovelView.bindData(title: data.novelTitle,
                               rating: data.novelRating, 
                               participants: data.novelRatingCount)
        
        let genres = data.genres.map { $0.withKorean }.joined(separator: ", ")
        
        genreLabel.do {
            $0.applyWSSFont(.body2, with: genres)
            $0.lineBreakMode = .byTruncatingTail
        }
        
        reactView.do {
            $0.bindData(likeRating: data.likeCount,
                        isLiked: data.isLiked,
                        commentRating: data.commentCount)
        }
    }
}
