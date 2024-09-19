//
//  LoginCarouselView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class LoginCarouselView: UIView {

    //MARK: - Components
   
    let bannerCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewLayout())
    private let bannerCollectionViewLayout = UICollectionViewFlowLayout()
    

    
    //MARK: - Life Cycle
    
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
        bannerCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 0
            $0.itemSize = CGSize(width: LoginCarouselMetric.collectionViewWidth,
                                 height:  LoginCarouselMetric.collectionViewHeight)
           bannerCollectionView.setCollectionViewLayout($0,
                                                        animated: false)
        }
        
        bannerCollectionView.do {
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.isPagingEnabled = true
        }
        
        bannerCollectionView.setContentOffset(CGPoint(x: LoginCarouselMetric.collectionViewWidth,
                                                      y: 0),
                                              animated: false)
    }
    
    private func setHierarchy() {
        self.addSubviews(bannerCollectionView)
    }
    
    private func setLayout() {
        bannerCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(LoginCarouselMetric.collectionViewHeight)
        }
    }
}

enum LoginCarouselMetric {
    static let imageRatio: CGFloat = 1.368
    static let collectionViewWidth = UIScreen.main.bounds.width
    static var collectionViewHeight: CGFloat {
        return UIScreen.isSE ? 460 : collectionViewWidth * imageRatio
    }
}
