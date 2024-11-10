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
    let tasteRecommendCollectionView = UICollectionView(frame: .zero,
                                                        collectionViewLayout: UICollectionViewLayout())
    private let tasteRecommendCollectionViewLayout = UICollectionViewFlowLayout()
    
    private let isLoggedIn = APIConstants.isLogined
    let unregisterView = HomeUnregisterView(.tasteRecommend)
    
    //MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
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
            $0.applyWSSFont(.headline1, with: StringLiterals.Home.Title.recommend)
            $0.textColor = .wssBlack
        }
        
        subTitleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Home.SubTitle.recommend)
            $0.textColor = .wssGray200
        }
        
        tasteRecommendCollectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
        }
        
        tasteRecommendCollectionViewLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 18
            $0.minimumInteritemSpacing = 9
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
            $0.itemSize = CGSize(width: (UIScreen.main.bounds.width - 49) / 2, height: 300)
            tasteRecommendCollectionView.setCollectionViewLayout($0, animated: false)
        }
        
        if isLoggedIn {
            subTitleLabel.isHidden = false
            tasteRecommendCollectionView.isHidden = false
            unregisterView.isHidden = true
        } else {
            subTitleLabel.isHidden = true
            tasteRecommendCollectionView.isHidden = true
            unregisterView.isHidden = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         subTitleLabel,
                         tasteRecommendCollectionView,
                         unregisterView)
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
        
        if isLoggedIn {
            subTitleLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(2)
                $0.leading.equalTo(titleLabel.snp.leading)
            }
            
            tasteRecommendCollectionView.snp.makeConstraints {
                $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(0)
                $0.bottom.equalToSuperview()
            }
        } else {
            unregisterView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(11)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(56)
            }
        }
    }
    
    //MARK: - Custom Method
    
    func updateCollectionViewHeight(height: CGFloat) {
        tasteRecommendCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
