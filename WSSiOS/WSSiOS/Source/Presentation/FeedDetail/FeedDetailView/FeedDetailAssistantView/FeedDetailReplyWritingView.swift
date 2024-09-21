//
//  FeedDetailReplyWritingView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 9/20/24.
//

import UIKit

import SnapKit
import Then

final class FeedDetailReplyWritingView: UIView {
    
    //MARK: - UI Components
    
    private let userProfileImageView = UIImageView()
    let textViewBackgroundView = UIView()
    private let replyWritingPlaceHolderLabel = UILabel()
    let replyWritingTextView = UITextView()
    private let replyButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        userProfileImageView.do {
            $0.image = .adminProfile
            $0.layer.cornerRadius = 14
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        textViewBackgroundView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
            
            replyWritingPlaceHolderLabel.do {
                $0.applyWSSFont(.body3, with: "댓글을 남겨보세요")
                $0.textColor = .wssGray200
            }
            
            replyWritingTextView.do {
                $0.textColor = .wssBlack
                $0.applyWSSFont(.body3, with: "")
                $0.tintColor = .wssBlack
                $0.backgroundColor = .wssGray50
                $0.textContainer.lineFragmentPadding = 0
                $0.textContainerInset = .zero
            }
            
            replyButton.do {
                $0.setImage(.icCommentRegister.withRenderingMode(.alwaysOriginal).withTintColor(.wssPrimary100), for: .normal)
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(userProfileImageView,
                         textViewBackgroundView)
        
        textViewBackgroundView.addSubviews(replyWritingTextView,
                                           replyButton)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(76)
        }
        
        userProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(42)
        }
        
        textViewBackgroundView.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.top)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
            
            replyWritingTextView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(16)
                $0.height.equalTo(19)
            }
            
            replyButton.snp.makeConstraints {
                $0.top.equalToSuperview().inset(7)
                $0.leading.equalTo(replyWritingTextView.snp.trailing)
                $0.trailing.equalToSuperview().inset(16)
                $0.size.equalTo(28)
            }
        }
    }
}
