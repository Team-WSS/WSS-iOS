//
//  FeedListTableViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

protocol FeedTableViewDelegate: AnyObject {
    func profileViewDidTap(userId: Int)
    func dropdownButtonDidTap(feedId: Int, isMyFeed: Bool)
    func connectedNovelViewDidTap(novelId: Int)
    func likeViewDidTap(feedId: Int, isLiked: Bool)
}

final class FeedListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    weak var delegate: FeedTableViewDelegate?
    
    private let feed = PublishRelay<TotalFeeds>()
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    let feedHeaderView = FeedListHeaderView()
    private let feedContentView = FeedListContentView()
    private let feedConnectedNovelView = FeedListConnectedNovelView()
    private let feedCategoryView = FeedListCategoryView()
    private let feedReactView = FeedListReactView()
    private let dividerView = UIView()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setHierarchy()
        setLayout()
        
        bindAction()
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
        contentView.addSubviews(stackView,
                                dividerView)
        stackView.addArrangedSubviews(feedHeaderView,
                                      feedContentView,
                                      feedConnectedNovelView,
                                      feedCategoryView,
                                      feedReactView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            
            stackView.do {
                $0.setCustomSpacing(12, after: feedHeaderView)
                $0.setCustomSpacing(20, after: feedContentView)
                $0.setCustomSpacing(24, after: feedCategoryView)
            }
        }
        
        dividerView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    //MARK: - Bind
    
    private func bindAction() {
        feedHeaderView.profileView.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(feed)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, feed in
                owner.delegate?.profileViewDidTap(userId: feed.userId)
            })
            .disposed(by: disposeBag)
        
        feedHeaderView.dropdownButtonView.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(feed)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, feed in
                owner.delegate?.dropdownButtonDidTap(feedId: feed.feedId, isMyFeed: feed.isMyFeed)
            })
            .disposed(by: disposeBag)
        
        feedConnectedNovelView.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(feed)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, feed in
                if let novelId = feed.novelId {
                    owner.delegate?.connectedNovelViewDidTap(novelId: novelId)
                }
            })
            .disposed(by: disposeBag)
        
        feedReactView.likeView.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(feed)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, feed in
                owner.delegate?.likeViewDidTap(feedId: feed.feedId, isLiked: feed.isLiked)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Data
    
    func bindData(feed: TotalFeeds) {
        self.feed.accept(feed)
        
        feedHeaderView.bindData(avatarImage: feed.avatarImage,
                                           nickname: feed.nickname,
                                           createdDate: feed.createdDate,
                                           isModified: feed.isModified)
        feedContentView.bindData(feedContent: feed.feedContent,
                                            isSpoiler: feed.isSpoiler)
        if let title = feed.title,
           let novelRatingCount = feed.novelRatingCount,
           let novelRating = feed.novelRating {
            feedConnectedNovelView.bindData(title: title,
                                                       novelRatingCount: novelRatingCount,
                                                       novelRating: novelRating)
            
            self.stackView.insertArrangedSubview(feedConnectedNovelView, at: 2)
            stackView.do {
                $0.setCustomSpacing(20, after: feedConnectedNovelView)
            }
        } else {
            feedConnectedNovelView.removeFromSuperview()
        }
        feedCategoryView.bindData(relevantCategories: feed.relevantCategories)
        feedReactView.bindData(isLiked: feed.isLiked,
                                          likeCount: feed.likeCount,
                                          commentCount: feed.commentCount)
    }
    
    func bindProfileData(feed: FeedCellData) {
        feedHeaderView.dropdownButtonView.isHidden = true
        
        let createdDate = feed.feed.createdDate
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        var formattedDate: String = ""

        if let date = inputDateFormatter.date(from: createdDate) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.locale = Locale(identifier: "ko_KR")
            outputDateFormatter.dateFormat = "M월 d일"
            formattedDate = outputDateFormatter.string(from: date)
        } else {
            formattedDate = ""
        }
        
        feedHeaderView.bindData(avatarImage: feed.avatarImage,
                                           nickname: feed.nickname,
                                           createdDate: formattedDate,
                                           isModified: feed.feed.isModified)
        feedContentView.bindData(feedContent: feed.feed.feedContent,
                                            isSpoiler: feed.feed.isSpoiler)
        if let title = feed.feed.title,
           let novelRatingCount = feed.feed.novelRatingCount,
           let novelRating = feed.feed.novelRating {
            feedConnectedNovelView.bindData(title: title,
                                                       novelRatingCount: novelRatingCount,
                                                       novelRating: novelRating)
            
            self.stackView.insertArrangedSubview(feedConnectedNovelView, at: 2)
            stackView.do {
                $0.setCustomSpacing(20, after: feedConnectedNovelView)
            }
        } else {
            feedConnectedNovelView.removeFromSuperview()
        }
        
        let translatedGenres = feed.feed.relevantCategories.compactMap {
            NewNovelGenre(rawValue: $0)?.withKorean
        }
        feedCategoryView.bindData(relevantCategories: translatedGenres)
        feedReactView.bindData(isLiked: feed.feed.isLiked,
                                          likeCount: feed.feed.likeCount,
                                          commentCount: feed.feed.commentCount)
    }
}
