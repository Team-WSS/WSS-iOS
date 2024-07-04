//
//  NovelDetailInfoReviewView.swift
//  WSSiOS
//
//  Created by 이윤학 on 7/1/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoReviewView: UIView {
    
    //MARK: - UI Components
    
    private let reviewStackView = UIStackView()
    private let titleLabel = UILabel()
    private let attractivePointView = NovelDetailInfoReviewAttractivePointView()
    let keywordCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewLayout())
    private let keywordCollectionViewLayout = UICollectionViewFlowLayout()
    
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
        self.do {
            $0.backgroundColor = .wssWhite
        }
        
        reviewStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        
        titleLabel.do {
            $0.applyWSSFont(.title1,
                            with: StringLiterals.NovelDetail.Info.attractivePoints)
            $0.textColor = .wssBlack
        }
        
        keywordCollectionView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        keywordCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 6
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            keywordCollectionView.setCollectionViewLayout($0,
                                                          animated: false)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(reviewStackView)
        reviewStackView.addArrangedSubviews(titleLabel,
                                            attractivePointView,
                                            keywordCollectionView)
    }
    
    private func setLayout() {
        reviewStackView.do {
            $0.setCustomSpacing(15, after: titleLabel)
            $0.setCustomSpacing(10, after: attractivePointView)
            
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().inset(35)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview().inset(40)
            }
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        attractivePointView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        keywordCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoResult) {
        attractivePointView.bindData(data)
    }
}
