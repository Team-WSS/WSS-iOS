//
//  NovelDetailFeedTableViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailFeedTableViewCell: UITableViewCell {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let novelDetailFeedHeaderView = NovelDetailFeedHeaderView()
    private let novelDetailFeedContentView = NovelDetailFeedContentView()
    private let novelDetailFeedConnectedNovelView = NovelDetailFeedConnectedNovelView()
    private let novelDetailFeedCategoryView = NovelDetailFeedCategoryView()
    private let novelDetailFeedReactView = NovelDetailFeedReactView()
    private let dividerView = UIView()
    
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
            $0.selectionStyle = .none
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(stackView,
                         dividerView)
        stackView.addArrangedSubviews(novelDetailFeedHeaderView,
                                      novelDetailFeedContentView,
                                      novelDetailFeedConnectedNovelView,
                                      novelDetailFeedCategoryView,
                                      novelDetailFeedReactView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            
            stackView.do {
                $0.setCustomSpacing(12, after: novelDetailFeedHeaderView)
                $0.setCustomSpacing(20, after: novelDetailFeedContentView)
                $0.setCustomSpacing(20, after: novelDetailFeedConnectedNovelView)
                $0.setCustomSpacing(24, after: novelDetailFeedCategoryView)
            }
        }
        
        dividerView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    //MARK: - Data
    
    func bindData(feed: NovelDetailFeed) {
        novelDetailFeedHeaderView.bindData(avatarImage: feed.avatarImage,
                                           nickname: feed.nickname,
                                           createdDate: feed.createdDate,
                                           isModified: feed.isModified)
        novelDetailFeedContentView.bindData(feedContent: feed.feedContent,
                                            isSpoiler: feed.isSpoiler)
        novelDetailFeedConnectedNovelView.bindData(title: feed.title,
                                                   novelRatingCount: feed.novelRatingCount,
                                                   novelRating: feed.novelRating)
        novelDetailFeedCategoryView.bindData(relevantCategories: feed.relevantCategories)
        novelDetailFeedReactView.bindData(isLiked: feed.isLiked,
                                          likeCount: feed.likeCount,
                                          commentCount: feed.commentCount)
    }
}
