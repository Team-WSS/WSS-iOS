//
//  FeedNovelView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
//

import UIKit

import SnapKit
import Then

final class FeedNovelView: UIView {
    
    //MARK: - Components
    
    let novelLinkIcon = UIImageView()
    let novelTitleLabel = UILabel()
    let novelStarIcon = UIImageView()
    let novelRatingLabel = UILabel()
    let novelRatingParticipantsLabel = UILabel()
    let rightArrowIcon = UIImageView()
    
    // MARK: - Life Cycle
    
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
        self.do {
            $0.backgroundColor = .wssPrimary20
            $0.layer.cornerRadius = 14
        }
        
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
            $0.tintColor = .wssGray200
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
    
    private func setHierarchy() {
        addSubviews(novelLinkIcon,
                    novelTitleLabel,
                    novelStarIcon,
                    novelRatingLabel,
                    novelRatingParticipantsLabel,
                    rightArrowIcon)
    }
    
    private func setLayout() {
        novelLinkIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(20)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(novelLinkIcon.snp.trailing).offset(6)
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
    
    func bindData(title: String, rating: Float, participants: Int) {
        novelTitleLabel.text = title
        novelRatingLabel.text = String(rating)
        novelRatingParticipantsLabel.text = " (" + String(participants) + ")"
    }
}
