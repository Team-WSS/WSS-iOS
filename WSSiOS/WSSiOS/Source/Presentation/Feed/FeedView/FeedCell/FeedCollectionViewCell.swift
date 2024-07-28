//
//  FeedCell.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class FeedCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    
    private let userView = FeedUserView()
    private let novelView = FeedNovelView()
    private let reactView = FeedReactView()
    private let detailContentView = FeedDetailContentView()
    
    private let dotIcon = UIImageView()
    private let restTimeLabel = UILabel()
    private let modifiedLabel = UILabel()
    private let dropdownIcon = UIImageView()
    private let genreLabel = UILabel()
    private let divideView = UIView()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        dotIcon.do {
            $0.image = UIImage(resource: .icDot)
        }
        
        restTimeLabel.do {
            $0.font = .Body5
            $0.textColor = .wssBlack
        }
        
        modifiedLabel.do {
            $0.text = StringLiterals.Feed.modifiedText
            $0.font = .Body5
            $0.textColor = .Gray200
        }
        
        dropdownIcon.do {
            $0.image = UIImage(resource: .icDropDownDot)
        }
        
        genreLabel.do {
            $0.font = .Body2
            $0.textColor = .Gray200
        }
        
        divideView.do {
            $0.backgroundColor = .Gray50
        }
    }
    
    private func setHierarchy() {
        addSubviews(userView,
                    dotIcon,
                    restTimeLabel,
                    modifiedLabel,
                    dropdownIcon,
                    detailContentView,
                    novelView,
                    genreLabel,
                    reactView,
                    divideView)
    }
    
    
    private func setLayout() {
        userView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        dotIcon.snp.makeConstraints {
            $0.centerY.equalTo(userView.snp.centerY)
            $0.leading.equalTo(userView.snp.trailing).offset(6)
            $0.size.equalTo(8)
        }
        
        restTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(dotIcon.snp.centerY)
            $0.leading.equalTo(dotIcon.snp.trailing).offset(6)
        }
        
        modifiedLabel.snp.makeConstraints {
            $0.centerY.equalTo(restTimeLabel.snp.centerY)
            $0.leading.equalTo(restTimeLabel.snp.trailing).offset(6)
        }
        
        //TODO: - 추후 extension 으로 수정
        dropdownIcon.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(40)
        }
        
        detailContentView.snp.makeConstraints {
            $0.top.equalTo(userView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        novelView.snp.makeConstraints {
            $0.top.equalTo(detailContentView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(novelView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        reactView.snp.makeConstraints {
            $0.top.equalTo(genreLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        
        divideView.snp.makeConstraints {
            $0.top.equalTo(reactView.snp.bottom).offset(24)
            $0.width.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    //MARK: - Data
    
    func bindData(data: TotalFeeds) {
        
        //TODO: - dropDown 설정하면서 myFeed 구분하기
        
        userView.bindData(imageURL: data.avatarImage,
                          nickname: data.nickname)
        
        restTimeLabel.text = data.createdDate
        modifiedLabel.isHidden = !data.isModified
        
        detailContentView.bindData(content: data.feedContent,
                                   isSpolier: data.isSpolier)
        
        novelView.bindData(title: data.title,
                           rating: data.novelRating,
                           participants: data.novelRatingCount)
        
        reactView.bindData(likeRating: data.likeCount,
                           isLiked: data.isLiked,
                           commentRating: data.commentCount)

        let categoriesText = data.relevantCategories
            .compactMap{
                FeedGenre(rawValue: $0)?.withKorean
            }.joined(separator: ", ")
        
        genreLabel.do {
            $0.text = categoriesText
            $0.makeAttribute(with: $0.text)?
                .lineSpacing(spacingPercentage: 0)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
        }
    }
}

