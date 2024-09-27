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
    let unregisterView = HomeUnregisterView(.interest)
    
    //MARK: - Life Cycle
    
    init(isLoggedIn: Bool) {
        super.init(frame: .zero)
        
        setUI(isLoggedIn: isLoggedIn)
        setHierarchy()
        setLayout(isLoggedIn: isLoggedIn)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(isLoggedIn: Bool) {
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: isLoggedIn ? "일이삼사오육칠팔구십\(StringLiterals.Home.Title.interest)" : StringLiterals.Home.Title.notLoggedInInterest)
            $0.textColor = .wssBlack
        }
        
        subTitleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Home.SubTitle.interest)
            $0.textColor = .wssGray200
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
        
        if isLoggedIn {
            subTitleLabel.isHidden = false
            unregisterView.isHidden = true
            interestCollectionView.isHidden = false
        }
        else {
            subTitleLabel.isHidden = true
            unregisterView.isHidden = false
            interestCollectionView.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         subTitleLabel,
                         interestCollectionView,
                         unregisterView)
    }
    
    private func setLayout(isLoggedIn: Bool) {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        if isLoggedIn {
            interestCollectionView.snp.makeConstraints {
                $0.top.equalTo(subTitleLabel.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(301)
            }
        }
        else {
            unregisterView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(11)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview()
            }
        }
    }
}
