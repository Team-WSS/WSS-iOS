//
//  NovelDetailFeedReactView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailFeedReactView: UIView {

    //MARK: - Components
    
    let likeView = UIView()
    private let likeImageView = UIImageView()
    private let likeLabel = UILabel()
    private let commentView = UIView()
    private let commentImageView = UIImageView()
    private let commentLabel = UILabel()
    
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
        likeImageView.do {
            $0.image = .icThumbUp
        }
        
        likeLabel.do {
            $0.textColor = .wssGray200
        }
        
        commentImageView.do {
            $0.image = .icComment
        }
        
        commentLabel.do {
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(likeView,
                         commentView)
        likeView.addSubviews(likeImageView,
                             likeLabel)
        commentView.addSubviews(commentImageView,
                                commentLabel)
    }
    
    private func setLayout() {
        likeView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.height.equalTo(37)
        }
        
        likeImageView.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        likeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(likeImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
        }
        
        commentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(likeView.snp.trailing).offset(18)
        }
        
        commentImageView.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        commentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(commentImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(isLiked: Bool, likeCount: Int, commentCount: Int) {
        likeImageView.image = isLiked ? .icThumbUpFill : .icThumbUp
        likeLabel.applyWSSFont(.body3, with: "\(likeCount)")
        commentLabel.applyWSSFont(.body3, with: "\(commentCount)")
    }
}
