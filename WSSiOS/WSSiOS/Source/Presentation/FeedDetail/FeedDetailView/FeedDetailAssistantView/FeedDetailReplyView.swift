//
//  FeedDetailReplyView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 6/24/24.
//

import UIKit

import SnapKit
import Then

final class FeedDetailReplyView: UIView {
    
    //MARK: - UI Components
    
    private let replyTitleStackView = UIStackView()
    private let replyTitleLabel = UILabel()
    let replyCountLabel = UILabel()
    let replyCollectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: UICollectionViewLayout())
    private let replyCollectionViewLayout = UICollectionViewFlowLayout()
    
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
        replyTitleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
        }
        
        replyTitleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.FeedDetail.reply)
            $0.textColor = .wssBlack
        }
        
        replyCountLabel.do {
            $0.textColor = .wssPrimary100
        }
        
        replyCollectionView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        replyCollectionViewLayout.do {
            $0.scrollDirection = .vertical
            $0.itemSize = CGSize(width: UIScreen.main.bounds.width-40, height: 45)
            $0.minimumLineSpacing = 22
            replyCollectionView.setCollectionViewLayout($0, animated: true)
        }
    }
    
    private func setHierarchy() {
        replyTitleStackView.addArrangedSubviews(replyTitleLabel,
                                                replyCountLabel)
        self.addSubviews(replyTitleStackView,
                         replyCollectionView)
    }
    
    private func setLayout() {
        replyTitleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        replyCollectionView.snp.makeConstraints {
            $0.top.equalTo(replyTitleStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bindData(commentCount: Int) {
        replyCountLabel.applyWSSFont(.title2, with: String(commentCount))
    }
}
