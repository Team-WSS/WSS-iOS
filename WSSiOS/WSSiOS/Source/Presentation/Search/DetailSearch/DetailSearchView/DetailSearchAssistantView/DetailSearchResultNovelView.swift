//
//  DetailSearchResultNovelView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 10/23/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchResultNovelView: UIView {
    
    //MARK: - UI Components
    
    let scrollView = UIScrollView()
    private let contentView = UIView()
    private let novelTitleLabel = UILabel()
    let novelCountLabel = UILabel()
    let resultNovelCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: UICollectionViewLayout())
    private let resultNovelCollectionViewLayout = UICollectionViewFlowLayout()
    
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
        novelTitleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.Search.novel)
            $0.textColor = .wssBlack
        }
        
        novelCountLabel.do {
            $0.textColor = .wssGray100
        }
        
        resultNovelCollectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
        }
        
        resultNovelCollectionViewLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 18
            $0.minimumInteritemSpacing = 9
            $0.itemSize = CGSize(width: (UIScreen.main.bounds.width - 49) / 2, height: 300)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
            resultNovelCollectionView.setCollectionViewLayout($0, animated: false)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(novelTitleLabel,
                         novelCountLabel,
                         resultNovelCollectionView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        novelCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(novelTitleLabel.snp.centerY)
            $0.leading.equalTo(novelTitleLabel.snp.trailing).offset(5)
        }
        
        resultNovelCollectionView.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
    }
    
    //MARK: - Custom Method
    
    func updateCollectionViewHeight(height: CGFloat) {
        resultNovelCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    func updateNovelCountLabel(count: Int) {
        novelCountLabel.applyWSSFont(.body4, with: String(describing: count))
    }
}
