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
    
    private var stackView = UIStackView()
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    let tasteRecommendCollectionView = UICollectionView(frame: .zero,
                                                        collectionViewLayout: UICollectionViewLayout())
    private let tasteRecommendCollectionViewLayout = UICollectionViewFlowLayout()
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
        stackView.do {
            $0.axis = .vertical
        }
        
        titleLabel.do {
            $0.applyWSSFont(.headline1, with: StringLiterals.Home.Title.recommend)
            $0.textColor = .wssBlack
        }
        
        subTitleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.Home.SubTitle.recommend)
            $0.textColor = .wssGray200
            $0.isHidden = true
        }
        
        tasteRecommendCollectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.isHidden = true
        }
        
        tasteRecommendCollectionViewLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 18
            $0.minimumInteritemSpacing = 9
            $0.itemSize = CGSize(width: (UIScreen.main.bounds.width - 49) / 2, height: 300)
            tasteRecommendCollectionView.setCollectionViewLayout($0, animated: false)
        }
        
        unregisterView.do {
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(titleLabel,
                                      subTitleLabel,
                                      tasteRecommendCollectionView,
                                      unregisterView)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(56)
        }
        
        tasteRecommendCollectionView.snp.makeConstraints {
            $0.height.equalTo(0)
        }
        
        unregisterView.snp.makeConstraints {
            $0.height.equalTo(133)
        }
    }
    
    //MARK: - Custom Method
    
    func updateView(_ isLogined: Bool, _ isEmpty: Bool) {
        if isLogined {
            if isEmpty {
                unregisterView.isHidden = false
                subTitleLabel.isHidden = true
                tasteRecommendCollectionView.isHidden = true
                
                stackView.do {
                    $0.setCustomSpacing(11, after: titleLabel)
                }
            } else {
                subTitleLabel.isHidden = false
                tasteRecommendCollectionView.isHidden = false
                unregisterView.isHidden = true
                
                stackView.do {
                    $0.setCustomSpacing(2, after: titleLabel)
                    $0.setCustomSpacing(20, after: subTitleLabel)
                    $0.snp.updateConstraints {
                        $0.bottom.equalToSuperview().inset(40)
                    }
                }
            }
        } else {
            unregisterView.isHidden = false
            subTitleLabel.isHidden = true
            tasteRecommendCollectionView.isHidden = true
            
            stackView.do {
                $0.setCustomSpacing(11, after: titleLabel)
            }
        }
    }
    
    func updateCollectionViewHeight(height: CGFloat) {
        tasteRecommendCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
