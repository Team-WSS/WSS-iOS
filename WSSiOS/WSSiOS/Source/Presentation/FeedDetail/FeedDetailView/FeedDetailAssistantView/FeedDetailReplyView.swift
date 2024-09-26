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
        replyCollectionView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        replyCollectionViewLayout.do {
            $0.scrollDirection = .vertical
            $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 45)
            $0.minimumLineSpacing = 22
            replyCollectionView.setCollectionViewLayout($0, animated: true)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(replyCollectionView)
    }
    
    private func setLayout() {
        replyCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(20)
        }
    }
    
    //MARK: - Custom Method
    
    func updateCollectionViewHeight(height: CGFloat) {
        replyCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
