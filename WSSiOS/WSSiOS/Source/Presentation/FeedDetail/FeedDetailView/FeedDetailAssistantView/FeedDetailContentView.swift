//
//  FeedDetailContentView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/23/24.
//

import UIKit

import SnapKit
import Then

final class FeedDetailContentView: UIView {
    
    //MARK: - UI Components
    
    private let stackView = UIStackView()
    private let contentWrapperView = UIView()
    private let contentLabel = UILabel()
    let addImageView = FeedDetailAddImageView()
    private let linkNovelWrapperView = UIView()
    let linkNovelView = FeedDetailNovelView()
    private let reactWrapperView = UIView()
    let reactView = FeedReactView()
    private let dividerView = UIView()
    
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
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.spacing = 30
        }
        
        contentLabel.do {
            $0.textColor = .wssBlack
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(stackView,
                         dividerView)
        contentWrapperView.addSubview(contentLabel)
        linkNovelWrapperView.addSubview(linkNovelView)
        reactWrapperView.addSubview(reactView)
        stackView.addArrangedSubviews(contentWrapperView,
                                      addImageView,
                                      linkNovelWrapperView,
                                      reactWrapperView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        [contentLabel, linkNovelView, reactView].forEach {
            $0.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview()
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(16)
            $0.height.equalTo(7)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func bindData(data: FeedEntity) {
        contentLabel.do {
            $0.applyWSSFont(.body2, with: data.feedContent)
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        if data.hasLinkedNovel {
            stackView.insertArrangedSubview(linkNovelWrapperView, at: 2)
            linkNovelView.bindData(novelData: data)
        } else {
            linkNovelWrapperView.removeFromSuperview()
        }
        
        reactView.do {
            $0.bindData(likeRating: data.likeCount,
                        isLiked: data.isLiked,
                        commentRating: data.commentCount)
        }
        
        if data.hasImage {
            stackView.insertArrangedSubview(addImageView, at: 1)
            stackView.setCustomSpacing(data.hasLinkedNovel ? 16 : 30, after: addImageView)
            addImageView.bindImages(imageURLs: data.imageURLs)
        } else {
            addImageView.removeFromSuperview()
        }
    }
}
