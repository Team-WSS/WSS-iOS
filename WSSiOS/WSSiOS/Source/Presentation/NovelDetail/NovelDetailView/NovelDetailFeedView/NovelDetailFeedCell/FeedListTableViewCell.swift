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
    
    private let feed = PublishRelay<TotalFeedEntity>()
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    let feedHeaderView = FeedListHeaderView()
    private let feedContentView = FeedListContentView()
    private let feedConnectedNovelView = FeedListConnectedNovelView()
    private let feedReactView = FeedListReactView()
    private let feedPrivateView = FeedListPrivateView()
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
                                      feedReactView,
                                      feedPrivateView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
            
            stackView.do {
                $0.setCustomSpacing(10, after: feedHeaderView)
                $0.setCustomSpacing(20, after: feedContentView)
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
                if (feed.novelId != -1) {
                    owner.delegate?.connectedNovelViewDidTap(novelId: feed.novelId)
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
    
    func bindFeedData(feed: TotalFeedEntity) {
        self.feed.accept(feed)
        
        feedHeaderView.bindData(avatarImage: feed.avatarImage,
                                nickname: feed.nickname,
                                createdDate: feed.createdDate,
                                isModified: feed.isModified)
        feedContentView.bindData(feedContent: feed.feedContent,
                                 isSpoiler: feed.isSpoiler)
        
        if (feed.title != "" && feed.novelRatingCount != -1 && feed.novelRating != -1) {
            feedConnectedNovelView.bindData(title: feed.title,
                                            novelRatingCount: feed.novelRatingCount,
                                            novelRating: feed.novelRating)
            
            self.stackView.insertArrangedSubview(feedConnectedNovelView, at: 2)
            stackView.do {
                $0.setCustomSpacing(10, after: feedConnectedNovelView)
            }
        } else {
            feedConnectedNovelView.removeFromSuperview()
        }
        
        if feed.isPublic {
            feedReactView.bindData(isLiked: feed.isLiked,
                                   likeCount: feed.likeCount,
                                   commentCount: feed.commentCount)
            feedPrivateView.removeFromSuperview()
            self.stackView.addArrangedSubview(feedReactView)
        } else {
            feedReactView.removeFromSuperview()
            self.stackView.addArrangedSubview(feedPrivateView)
        }
    }
    
    func bindProfileFeedData(feed: MyFeedListItem) {
        feedHeaderView.dropdownButtonView.isHidden = true
        feedHeaderView.bindData(avatarImage: feed.avatarImage,
                                nickname: feed.nickname,
                                createdDate: feed.feed.createdDate,
                                isModified: feed.feed.isModified)
        feedContentView.bindData(feedContent: feed.feed.feedContent,
                                 isSpoiler: feed.feed.isSpoiler)
        feedReactView.bindData(isLiked: feed.feed.isLiked,
                               likeCount: feed.feed.likeCount,
                               commentCount: feed.feed.commentCount)
        
        //연결된 소설 유무에 따른 UI 조정
        if feed.feed.novelId != -1,
           !feed.feed.title.isEmpty,
           feed.feed.novelRatingCount != -1,
           feed.feed.novelRating != -1 {
            feedConnectedNovelView.bindData(title: feed.feed.title,
                                            novelRatingCount: feed.feed.novelRatingCount,
                                            novelRating: feed.feed.novelRating)
            self.stackView.insertArrangedSubview(feedConnectedNovelView, at: 2)
            stackView.do {
                $0.setCustomSpacing(10, after: feedConnectedNovelView)
            }
        } else {
            feedConnectedNovelView.removeFromSuperview()
        }
        
        // 피드 공개 여부에 따른 UI 조정
        if feed.feed.isPublic {
            feedPrivateView.removeFromSuperview()
            self.stackView.addArrangedSubview(feedReactView)
        } else {
            feedReactView.removeFromSuperview()
            self.stackView.addArrangedSubview(feedPrivateView)
        }
    }
}
