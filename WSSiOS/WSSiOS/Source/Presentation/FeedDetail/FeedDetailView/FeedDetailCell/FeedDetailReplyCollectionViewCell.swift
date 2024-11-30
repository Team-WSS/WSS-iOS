//
//  FeedDetailReplyCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/24/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

protocol FeedDetailReplyCollectionDelegate: AnyObject {
    func profileViewDidTap(userId: Int)
    func dotsButtonDidTap(commentId: Int, isMyComment: Bool)
    func spoilerTextDidTap()
}

final class FeedDetailReplyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    weak var delegate: FeedDetailReplyCollectionDelegate?
    
    private let comment = PublishRelay<FeedComment>()
    
    //MARK: - Components
    
    private var userProfileImageView = UIImageView()
    private let userStackview = UIStackView()
    private let userNicknameLabel = UILabel()
    private let dotImageView = UIImageView()
    private let createdDateLabel = UILabel()
    private let isModifiedLabel = UILabel()
    private let replyContentLabel = UILabel()
    private let threeDotsButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        userProfileImageView.do {
            $0.image = .imgLoadingThumbnail
            $0.layer.cornerRadius = 12
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        userStackview.do {
            $0.axis = .horizontal
            $0.spacing = 6
        }
        
        userNicknameLabel.do {
            $0.textColor = .wssBlack
        }
        
        dotImageView.do {
            $0.image = .icBlackDot
            $0.contentMode = .scaleAspectFit
        }
        
        createdDateLabel.do {
            $0.textColor = .wssBlack
        }
        
        isModifiedLabel.do {
            $0.applyWSSFont(.body5, with: StringLiterals.Feed.modifiedText)
            $0.textColor = .wssGray200
        }

        threeDotsButton.do {
            $0.setImage(.icThreedots.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray200), for: .normal)
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setHierarchy() {
        userStackview.addArrangedSubviews(userNicknameLabel,
                                          dotImageView,
                                          createdDateLabel,
                                          isModifiedLabel)
        self.addSubviews(userProfileImageView,
                         userStackview,
                         replyContentLabel,
                         threeDotsButton)
    }
    
    private func setLayout() {
        userProfileImageView.snp.makeConstraints {
            $0.size.equalTo(42)
            $0.top.equalToSuperview().inset(2.5)
            $0.leading.equalToSuperview().inset(20)
        }
        
        userStackview.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(14)
        }
        
        replyContentLabel.snp.makeConstraints {
            $0.top.equalTo(userStackview.snp.bottom)
            $0.leading.equalTo(userStackview.snp.leading)
            $0.trailing.equalTo(threeDotsButton.snp.leading).offset(-14)
            $0.bottom.equalToSuperview()
        }
        
        threeDotsButton.snp.makeConstraints {
            $0.size.equalTo(42)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(userProfileImageView.snp.centerY)
        }
    }
    
    //MARK: - Bind
    
    private func bindAction() {
        userProfileImageView.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(comment)
            .subscribe(with: self, onNext: { owner, comment in
                owner.delegate?.profileViewDidTap(userId: comment.userId)
            })
            .disposed(by: disposeBag)
        
        threeDotsButton.rx.tap
            .withLatestFrom(comment)
            .subscribe(with: self, onNext: { owner, comment in
                owner.delegate?.dotsButtonDidTap(commentId: comment.commentId, isMyComment: comment.isMyComment)
            })
            .disposed(by: disposeBag)

        replyContentLabel.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(comment)
            .filter { $0.isSpoiler }
            .subscribe(with: self, onNext: { owner, comment in
                owner.delegate?.spoilerTextDidTap()
                owner.showFullText(for: comment)
            })
            .disposed(by: disposeBag)
    }
    
    private func showFullText(for comment: FeedComment) {
        replyContentLabel.applyWSSFont(.body2, with: comment.commentContent)
        replyContentLabel.textColor = .wssBlack
        replyContentLabel.numberOfLines = 0
    }
    
    func bindData(data: FeedComment) {
        self.comment.accept(data)
        
        self.userProfileImageView.kfSetImage(url: makeBucketImageURLString(path: data.userProfileImage))
        self.userNicknameLabel.do {
            if data.userId == -1 {
                // 탈퇴 유저
                $0.applyWSSFont(.title2, with: StringLiterals.FeedDetail.deleteAccountUserNickname)
            } else if data.isBlocked {
                $0.applyWSSFont(.title2, with: StringLiterals.FeedDetail.blckedUser)
            } else {
                $0.applyWSSFont(.title2, with: data.userNickname)
            }
        }
        self.createdDateLabel.applyWSSFont(.body5, with: data.createdDate)
        self.isModifiedLabel.isHidden = !data.isModified
        self.replyContentLabel.do {
            if data.isBlocked {
                // 차단 유저
                $0.applyWSSFont(.body2, with: StringLiterals.FeedDetail.blockedComment)
                $0.textColor = .wssGray200
                $0.isUserInteractionEnabled = false
            } else if data.isHidden {
                // 숨김 처리
                $0.applyWSSFont(.body2, with: StringLiterals.FeedDetail.hiddenComment)
                $0.textColor = .wssGray200
                $0.isUserInteractionEnabled = false
            } else if data.isSpoiler {
                // 스포일러 댓글
                $0.applyWSSFont(.body2, with: StringLiterals.FeedDetail.spoilerComment)
                $0.textColor = .wssSecondary100
                $0.isUserInteractionEnabled = true
            } else {
                // 일반 댓글
                $0.applyWSSFont(.body2, with: data.commentContent)
                $0.textColor = .wssBlack
                $0.numberOfLines = 0
                $0.isUserInteractionEnabled = false
            }
        }
        
        self.threeDotsButton.isHidden = data.isHidden || data.isBlocked || data.userId == -1
    }
}
