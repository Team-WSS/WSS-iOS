//
//  NormalSearchTableViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchTableViewCell: UITableViewCell {
    
    //MARK: - Components
    ///소설 정보
    private let novelImageView = UIImageView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    
    /// 좋아요 정보
    private let likeImageView = UIImageView()
    private let likeCountLabel = UILabel()
    
    /// 평점 정보
    private let ratingImageView = UIImageView()
    private let ratingAverageLabel = UILabel()
    private let ratingCountLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
            $0.backgroundColor = .white
            $0.selectionStyle = .none
        }
        
        novelImageView.do {
            $0.image = .imgTest2
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        novelTitleLabel.do {
            $0.fontTitle3Attribute(with: "여주인공의 이해를 돕기 위하여")
            $0.textColor = .wssBlack
            $0.lineBreakMode = .byTruncatingTail
        }
        
        novelAuthorLabel.do {
            $0.fontBody5Attribute(with: "구리스, 최서연")
            $0.textColor = .wssGray200
            $0.lineBreakMode = .byTruncatingTail
        }
        
        likeImageView.do {
            $0.image = .icHeart
        }
        
        likeCountLabel.do {
            $0.fontBody5Attribute(with: "123")
            $0.textColor = .wssGray200
        }
        
        ratingImageView.do {
            $0.image = .icStar2
        }
        
        ratingAverageLabel.do {
            $0.fontBody5Attribute(with: "2.34")
            $0.textColor = .wssGray200
        }
        
        ratingCountLabel.do {
            $0.fontBody5Attribute(with: "(123)")
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelImageView,
                         novelTitleLabel,
                         novelAuthorLabel,
                         likeImageView,
                         likeCountLabel,
                         ratingImageView,
                         ratingAverageLabel,
                         ratingCountLabel)
    }
    
    private func setLayout() {
        novelImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(78)
            $0.height.equalTo(105)
        }
        
        likeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(21)
            $0.leading.equalTo(novelImageView.snp.trailing).offset(18)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeImageView.snp.centerY)
            $0.leading.equalTo(likeImageView.snp.trailing)
        }
        
        ratingImageView.snp.makeConstraints {
            $0.top.equalTo(likeImageView.snp.top)
            $0.leading.equalTo(likeCountLabel.snp.trailing).offset(8)
        }
        
        ratingAverageLabel.snp.makeConstraints {
            $0.centerY.equalTo(ratingImageView.snp.centerY)
            $0.leading.equalTo(ratingImageView.snp.trailing)
        }
        
        ratingCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(ratingImageView.snp.centerY)
            $0.leading.equalTo(ratingAverageLabel.snp.trailing).offset(2)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(likeImageView.snp.bottom).offset(9)
            $0.leading.equalTo(likeImageView.snp.leading)
        }
        
        novelAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom).offset(7)
            $0.leading.equalTo(likeImageView.snp.leading)
        }
    }
}
