//
//  FeedDetailAddImageViewerView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/20/25.
//

import UIKit

import SnapKit
import Then

final class FeedDetailAddImageViewerView: UIView {
    
    //MARK: - Components
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let collectionViewLayout = UICollectionViewFlowLayout()
    
    let closeButton = UIButton(type: .system)
    let pageLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        collectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 0
            collectionView.setCollectionViewLayout($0, animated: true)
        }
        
        collectionView.do {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .black
        }
        
        closeButton.do {
            $0.setImage(.icCancelModal
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssWhite), for: .normal)
        }
        
        pageLabel.do {
            $0.textColor = .wssWhite
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(collectionView,
                         closeButton,
                         pageLabel)
    }
    
    private func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(1)
            $0.leading.equalToSuperview().offset(6)
        }
        
        pageLabel.snp.makeConstraints {
            $0.centerY.equalTo(closeButton.snp.centerY)
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Custom Methods
    
    func updatePageLabel(for index: Int, imageCount: Int) {
        pageLabel.applyWSSFont(.title2, with: "\(index + 1) / \(imageCount)")
    }
}
