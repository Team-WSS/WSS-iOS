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
    
    private let userView = UIView()
    private let userImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    
    private let dotIcon = UIImageView()
    private let restTimeLabel = UILabel()
    
    private let dropdownIcon = UIImageView()
    
    private let detailContentView = UIView()
    private let detailContentLabel = UILabel()
    
    private let novelView = UIView()
    private let novelLinkIcon = UIImageView()
    private let novelTitleLabel = UILabel()
    private let novelStarIcon = UIImageView()
    private let novelRatingLabel = UILabel()
    private let novelRatingParticipantsLabel = UILabel()
    private let rightArrowIcon = UIImageView()
    
    private let genreLabel = UILabel()
    
    private let likeView = UIView()
    private let likeIcon = UIImageView()
    private let likeRatingLabel = UILabel()
    
    private let commentView = UIView()
    private let commentIcon = UIImageView()
    private let commentRatingLabel = UILabel()
    
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
        
        userView.do {
            $0.backgroundColor = .clear
            
            userImageView.do {
                $0.contentMode = .scaleAspectFill
                $0.layer.cornerRadius = 14
            }
            
            userNicknameLabel.do {
                $0.font = .Title2
                $0.textColor = .wssBlack
            }
        }
        
        dotIcon.do {
            $0.image = UIImage(resource: .icDot)
        }
        
        restTimeLabel.do {
            $0.font = .Body5
            $0.textColor = .wssBlack
        }
        
        dropdownIcon.do {
            $0.image = UIImage(resource: .icDropDownDot)
        }
        
        detailContentView.do {
            $0.backgroundColor = .clear
            
            detailContentLabel.do {
                $0.font = .Body2
                $0.textColor = .wssBlack
                $0.textAlignment = .left
                $0.lineBreakMode = .byTruncatingTail
                $0.lineBreakStrategy = .hangulWordPriority
            }
        }
        
        novelView.do {
            $0.backgroundColor = .clear
            
            novelLinkIcon.do {
                $0.image = UIImage(resource: .icNovelLink)
                $0.tintColor = .wssPrimary100
            }
            
            novelTitleLabel.do {
                $0.font = .Title3
                $0.textColor = .wssBlack
            }
            
            novelStarIcon.do {
                $0.image = UIImage(resource: .icPinkStar)
            }
            
            [novelRatingLabel,novelRatingParticipantsLabel].forEach {
                $0.do {
                    $0.font = .Label1
                    $0.textColor = .wssBlack
                }
            }
            
            rightArrowIcon.do {
                $0.image = UIImage(resource: .icNavigateRight)
                $0.tintColor = .Gray100
            }
        }
        
        genreLabel.do {
            $0.font = .Body2
            $0.textColor = .Gray200
        }
        
        likeView.do {
            $0.backgroundColor = .clear
            
            likeIcon .do {
                $0.image = UIImage(resource: .icThumbUp)
                $0.tintColor = .Gray200
            }
            
            likeRatingLabel.do {
                $0.font = .Body5
                $0.textColor = .Gray200
            }
        }
        
        commentView.do {
            $0.backgroundColor = .clear
            
            commentIcon.do {
                $0.image = UIImage(resource: .icComment)
                $0.tintColor = .Gray200
            }
            
            commentRatingLabel.do {
                $0.font = .Body5
                $0.textColor = .Gray200
            }
        }
    }
    
    private func setHierarchy() {
        addSubviews(userView,
                    dotIcon,
                    restTimeLabel,
                    dropdownIcon,
                    detailContentView,
                    novelView,
                    genreLabel,
                    likeView,
                    commentView)
        
        userView.addSubviews(userImageView,
                             userNicknameLabel)
        
        detailContentView.addSubview(detailContentLabel)
        
        novelView.addSubviews(novelLinkIcon,
                              novelTitleLabel,
                              novelStarIcon,
                              novelRatingLabel,
                              novelRatingParticipantsLabel,
                              rightArrowIcon)
        
        likeView.addSubviews(likeIcon,
                             likeRatingLabel)
        
        commentView.addSubviews(commentIcon,
                                commentRatingLabel)
    }
    
    
    private func setLayout() {
        userView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(20)
            
            userImageView.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.size.equalTo(42)
            }
            
            userNicknameLabel.snp.makeConstraints {
                $0.centerY.equalTo(userImageView.snp.centerX)
                $0.leading.equalTo(userImageView.snp.trailing).offset(14)
                $0.trailing.equalToSuperview()
            }
        }
        
        dotIcon.snp.makeConstraints {
            $0.centerX.equalTo(userImageView.snp.centerX)
            $0.leading.equalTo(userImageView.snp.trailing).offset(6)
            $0.size.equalTo(8)
        }
        
        restTimeLabel.snp.makeConstraints {
            $0.centerX.equalTo(dotIcon.snp.centerX)
            $0.leading.equalTo(dotIcon.snp.trailing).offset(6)
        }
        
        //TODO: - 추후 수정
        dropdownIcon.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(40)
        }
        
        
        detailContentView.snp.makeConstraints {
            $0.top.equalTo(userView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(115)
            
            detailContentLabel.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        novelView.snp.makeConstraints {
            $0.top.equalTo(detailContentView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
            
            novelLinkIcon.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(16)
                $0.size.equalTo(20)
            }
            
            novelTitleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(novelLinkIcon.snp.trailing).offset(6)
                $0.size.equalTo(20)
            }
            
            rightArrowIcon.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(15)
                $0.size.equalTo(18)
            }
            
            novelRatingParticipantsLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalTo(rightArrowIcon.snp.leading).offset(-10)
            }
            
            novelRatingLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalTo(novelRatingParticipantsLabel.snp.leading)
            }
            
            novelStarIcon.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalTo(novelRatingLabel.snp.leading).offset(-5)
                $0.size.equalTo(12)
            }
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(novelView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().inset(20)
        }
        
        likeView.snp.makeConstraints {
            $0.top.equalTo(genreLabel.snp.bottom).offset(28)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(28)
            
            likeIcon.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview().inset(8)
                $0.size.equalTo(22)
            }
            
            likeRatingLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(likeIcon.snp.trailing).offset(4)
                $0.trailing.equalToSuperview().inset(8)
            }
        }
        
        commentView.snp.makeConstraints {
            $0.top.equalTo(likeView.snp.top)
            $0.leading.equalTo(likeView.snp.trailing).offset(6)
            $0.bottom.equalTo(likeView.snp.bottom)
            
            commentIcon.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview().inset(8)
                $0.size.equalTo(22)
            }
            
            commentRatingLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(likeIcon.snp.trailing).offset(4)
                $0.trailing.equalToSuperview().inset(8)
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(data: TotalFeeds) {
        userImageView.kfSetImage(url: data.avatarImage)
        userNicknameLabel.text = data.nickname
        
        //TODO: 추후 수정
        restTimeLabel.text = data.createdDate
        
        detailContentLabel.text = data.feedContent
        novelTitleLabel.text = data.title
        novelRatingLabel.text = String(data.novelRating)
        novelRatingParticipantsLabel.text = String(data.novelRatingCount)
        likeRatingLabel.text = String(data.likeCount)
        commentRatingLabel.text = String(data.commentCount)
        
        let categoriesText = data.relevantCategories.joined(separator: " · ")
        genreLabel.text = categoriesText
    }
}

