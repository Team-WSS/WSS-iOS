//
//  FeedCell.swift
//  WSSiOS
//
//  Created by 신지원 on 5/14/24.
//

import UIKit

import RxSwift
import Kingfisher
import SnapKit
import Then

final class FeedCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private var isLiked = true
    private var isLikedCount = 0
    var disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    let userView = FeedUserView()
    let novelView = FeedNovelView()
    let reactView = FeedReactView()
    let detailContentView = FeedContentView()
    private let genreLabel = UILabel()
    private let emptyView = UIView()
    private let divideView = UIView()
    
    var profileTapHandler: (() -> Void)?
    var contentTapHandler: (() -> Void)?
    var novelTapHandler: (() -> Void)?
    var likedTapHandler: (() -> Void)?
    var commentTapHandler: (() -> Void)?
    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        
        addTapGestures()
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
        
        stackView.do {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .leading
        }
        
        genreLabel.do {
            $0.textColor = .wssGray200
        }
        
        divideView.do {
            $0.backgroundColor = .wssGray50
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(stackView,
                         divideView)
        stackView.addArrangedSubviews(userView,
                                      detailContentView,
                                      novelView,
                                      genreLabel,
                                      reactView,
                                      emptyView)
    }
    
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
            
            stackView.do {
                $0.setCustomSpacing(12, after: userView)
                $0.setCustomSpacing(20, after: detailContentView)
                $0.setCustomSpacing(20, after: novelView)
                $0.setCustomSpacing(24, after: genreLabel)
            }
        }
        
        userView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(38)
        }
        
        detailContentView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        novelView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(48)
            
        }
        
        reactView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(37)
        }
        
        emptyView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        divideView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.width.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    //MARK: - Action
    
    private func addTapGestures() {
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleProfileTap))
        userView.addGestureRecognizer(profileTap)
        userView.isUserInteractionEnabled = true
        
        let contentTap = UITapGestureRecognizer(target: self, action: #selector(handleContentTap))
        detailContentView.addGestureRecognizer(contentTap)
        detailContentView.isUserInteractionEnabled = true
        
        let novelTap = UITapGestureRecognizer(target: self, action: #selector(handleNovelTap))
        novelView.addGestureRecognizer(novelTap)
        novelView.isUserInteractionEnabled = true
        
        let likedTap = UITapGestureRecognizer(target: self, action: #selector(handleLikedTap))
        reactView.likeIcon.addGestureRecognizer(likedTap)
        reactView.likeIcon.isUserInteractionEnabled = true
        
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(handleCommentTap))
        reactView.commentView.addGestureRecognizer(commentTap)
        reactView.commentView.isUserInteractionEnabled = true
    }
    
    @objc private func handleProfileTap() {
        profileTapHandler?()
    }
    
    @objc private func handleContentTap() {
        contentTapHandler?()
    }
    
    @objc private func handleNovelTap() {
        novelTapHandler?()
    }
    
    @objc private func handleLikedTap() {
        likedTapHandler?()
        
        isLiked.toggle()
        reactView.updateLikeState(isLiked)
        isLikedCount = isLiked ? isLikedCount + 1 : isLikedCount - 1
        reactView.updateLikeCount(isLikedCount)
    }
    
    @objc private func handleCommentTap() {
        commentTapHandler?()
    }
    
    //MARK: - Data
    
    func bindData(data: TotalFeeds) {
        
        //TODO: - dropDown 설정하면서 myFeed 구분하기
        
        userView.bindData(imageURL: data.avatarImage,
                          nickname: data.nickname,
                          createdDate: data.createdDate,
                          isModified: data.isModified)
        
        detailContentView.bindData(content: data.feedContent,
                                   isSpolier: data.isSpoiler)
        
        if data.title == nil {
            if let index = stackView.arrangedSubviews.firstIndex(of: novelView) {
                stackView.removeArrangedSubview(novelView)
                novelView.removeFromSuperview()
            }
        } else {
            if let index = stackView.arrangedSubviews.firstIndex(of: genreLabel) {
                if !stackView.arrangedSubviews.contains(novelView) {
                    stackView.insertArrangedSubview(novelView, at: index)
                }
            }
            
            novelView.bindData(
                title: data.title ?? "",
                rating: data.novelRating ?? -1,
                participants: data.novelRatingCount ?? -1
            )
        }
        
        reactView.bindData(likeRating: data.likeCount,
                           isLiked: data.isLiked,
                           commentRating: data.commentCount)
        
        isLiked = data.isLiked
        isLikedCount = data.likeCount
        
        let categoriesText = data.relevantCategories
            .joined(separator: ", ")
        
        genreLabel.applyWSSFont(.body2, with: categoriesText)
    }
}

