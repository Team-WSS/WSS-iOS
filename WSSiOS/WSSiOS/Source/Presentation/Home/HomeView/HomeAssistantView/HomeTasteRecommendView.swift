//
//  HomeTasteRecommendView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/9/24.
//

import UIKit

import SnapKit
import Then

final class HomeTasteRecommendView: UIView {
    
    //MARK: - UI Components
    
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    
    private var testView = HomeTasteRecommendCollectionViewCell()
    
    let tasteRecommendCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewLayout())
    private let tasteRecommendCollectionViewLayout = UICollectionViewFlowLayout()
    
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
        titleLabel.do {
            $0.font = .HeadLine1
            $0.textColor = .wssBlack
            $0.makeAttribute(with: "이 웹소설은 어때요?")?
                .kerning(kerningPixel: -1.2)
                .applyAttribute()
        }
        
        subTitleLabel.do {
            $0.font = .Body2
            $0.textColor = .wssGray200
            $0.makeAttribute(with: "선호장르를 기반으로 추천해 드려요")?
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
        }
        
        tasteRecommendCollectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
        }
        
        tasteRecommendCollectionViewLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 18
            $0.minimumInteritemSpacing = 9
            $0.itemSize = CGSize(width: (UIScreen.main.bounds.width - 49) / 2, height: 319)
            tasteRecommendCollectionView.setCollectionViewLayout($0, animated: false)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         subTitleLabel,
                         tasteRecommendCollectionView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        tasteRecommendCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
