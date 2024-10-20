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
    
    private let likeView = UIView()
    let likeButton = UIButton()
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
        
        likeButton.do {
            $0.setImage(.icThumbUp.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray200), for: .normal)
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
        
        likeView.addSubviews(likeButton,
                             likeRatingLabel)
        
        commentView.addSubviews(commentIcon,
                                commentRatingLabel)
    }
    
    private func setLayout() {
        likeView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            
            likeButton.snp.makeConstraints {
                $0.top.bottom.centerY.leading.equalToSuperview()
                $0.size.equalTo(20)
            }
            
            likeRatingLabel.snp.makeConstraints {
                $0.centerY.trailing.equalToSuperview()
                $0.leading.equalTo(likeButton.snp.trailing).offset(5)
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
        likeButton.setImage(isLiked ? .icThumbUpFill : .icThumbUp, for: .normal)
        likeRatingLabel.applyWSSFont(.title3, with: String(likeRating))
        commentRatingLabel.applyWSSFont(.title3, with: String(commentRating))
    }
    
    func updateLikeState(_ isLiked: Bool) {
        likeButton.setImage(isLiked ? .icThumbUpFill : .icThumbUp, for: .normal)
    }
    
    func updateLikeCount(_ count: Int) {
        likeRatingLabel.applyWSSFont(.title3, with: String(count))
    }
    
    func updateCommentCount(_ count: Int) {
        commentRatingLabel.applyWSSFont(.title3, with: String(count))
    }
}
