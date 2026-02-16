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
    let linkNovelView = FeedDetailNovelView()
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
        self.addSubview(stackView)
        contentWrapperView.addSubview(contentLabel)
        stackView.addArrangedSubviews(contentWrapperView,
                                      addImageView,
                                      linkNovelView,
                                      reactView,
                                      dividerView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
        
        addImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        linkNovelView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(123)
        }
        
        reactView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        dividerView.snp.makeConstraints {
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
        
        addImageView.isHidden = !data.hasImage
        if data.hasImage {
            addImageView.bindImages(imageURLs: data.imageURLs)
        }
        
        linkNovelView.isHidden = !data.hasLinkedNovel
        if let novelData = data.novelData {
            linkNovelView.bindData(novelData: novelData)
        }
        
        reactView.do {
            $0.bindData(likeRating: data.likeCount,
                        isLiked: data.isLiked,
                        commentRating: data.commentCount)
        }
        
        applySpacing(hasImage: data.hasImage,
                     hasLinkedNovel: data.hasLinkedNovel)
    }
    
    private func applySpacing(hasImage: Bool, hasLinkedNovel: Bool) {
        stackView.setCustomSpacing(30, after: contentWrapperView)
        stackView.setCustomSpacing(30, after: addImageView)
        stackView.setCustomSpacing(30, after: linkNovelView)
        stackView.setCustomSpacing(30, after: reactView)
        
        if hasImage && hasLinkedNovel {
            stackView.setCustomSpacing(16, after: addImageView)
        }
        
        stackView.setCustomSpacing(16, after: reactView)
    }
}
