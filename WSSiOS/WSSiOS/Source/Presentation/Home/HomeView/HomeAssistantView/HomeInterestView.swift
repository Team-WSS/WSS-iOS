//
//  HomeInterestView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/2/24.
//

import UIKit

import SnapKit
import Then

final class HomeInterestView: UIView {
    
    //MARK: - UI Components
    
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    
    let interestCollectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    private let interestCollectionViewLayout = UICollectionViewFlowLayout()
    private let unregisterView = HomeUnregisterView(.interest)
    
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
            $0.makeAttribute(with: "일이삼사오육칠팔구십 \(StringLiterals.Home.Title.interest)")?
                .kerning(kerningPixel: -1.2)
                .applyAttribute()
        }
        
        subTitleLabel.do {
            $0.font = .Body2
            $0.textColor = .wssGray200
            $0.makeAttribute(with: StringLiterals.Home.SubTitle.interest)?
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
        }
        
        interestCollectionView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        interestCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 12
            $0.itemSize = CGSize(width: 280, height: 251)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            interestCollectionView.setCollectionViewLayout($0, animated: false)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         subTitleLabel,
                         interestCollectionView)
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
        
        interestCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(301)
        }
        
        /// 비로그인일 때
//        unregisterView.snp.makeConstraints {
//            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
//            $0.leading.trailing.equalToSuperview().inset(20)
//        }
    }
}
