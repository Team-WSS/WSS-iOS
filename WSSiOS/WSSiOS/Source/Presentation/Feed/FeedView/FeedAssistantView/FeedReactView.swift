//
//  FeedReactView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
//

import UIKit

import SnapKit
import Then

final class FeedReactView: UIView {
    
    //MARK: - Components
    
    let likeView = UIView()
    let likeIcon = UIImageView()
    let likeRatingLabel = UILabel()
    
    let commentView = UIView()
    private let commentIcon = UIImageView()
    private let commentRatingLabel = UILabel()
    
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
        self.backgroundColor = .wssWhite
        
        likeView.do {
            $0.backgroundColor = .wssWhite
        }
        
        likeIcon.do {
            $0.image = .icThumbUp.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray200)
            $0.contentMode = .scaleAspectFit
        }
        
        likeRatingLabel.do {
            $0.textColor = .wssGray200
        }
        
        commentView.do {
            $0.backgroundColor = .wssWhite
        }
        
        commentIcon.do {
            $0.image = .icComment
            $0.contentMode = .scaleAspectFit
        }
        
        commentRatingLabel.do {
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(likeView,
                         commentView)
        
        likeView.addSubviews(likeIcon,
                             likeRatingLabel)
        
        commentView.addSubviews(commentIcon,
                                commentRatingLabel)
    }
    
    private func setLayout() {
        likeView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            
            likeIcon.snp.makeConstraints {
                $0.top.bottom.centerY.leading.equalToSuperview()
                $0.size.equalTo(20)
            }
            
            likeRatingLabel.snp.makeConstraints {
                $0.centerY.trailing.equalToSuperview()
                $0.leading.equalTo(likeIcon.snp.trailing).offset(5)
            }
        }
        
        commentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(likeView.snp.trailing).offset(18)
            
            commentIcon.snp.makeConstraints {
                $0.centerY.leading.equalToSuperview()
                $0.size.equalTo(20)
            }
            
            commentRatingLabel.snp.makeConstraints {
                $0.centerY.trailing.equalToSuperview()
                $0.leading.equalTo(commentIcon.snp.trailing).offset(5)
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(likeRating: Int, isLiked: Bool, commentRating: Int) {
        likeIcon.image = isLiked ? .icThumbUpFill : .icThumbUp
        likeRatingLabel.applyWSSFont(.title3, with: String(likeRating))
        commentRatingLabel.applyWSSFont(.title3, with: String(commentRating))
    }
    
    func updateLikeState(_ isLiked: Bool) {
        likeIcon.image = isLiked ? .icThumbUpFill : .icThumbUp
    }
    
    func updateLikeCount(_ count: Int) {
        likeRatingLabel.applyWSSFont(.title3, with: String(count))
    }
    
    func updateCommentCount(_ count: Int) {
        commentRatingLabel.applyWSSFont(.title3, with: String(count))
    }
}
