//
//  TrashNovelDetailInfoKeywordView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class TrashNovelDetailInfoKeywordView: UIView {

    //MARK: - Components
    
    private let keywordLabel = UILabel()
    let keywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
//        keywordLabel.do {
//            $0.makeAttribute(with: StringLiterals.NovelDetail.Info.keyword)?
//                .kerning(kerningPixel: -0.6)
//                .applyAttribute()
//            $0.textColor = .wssBlack
//            $0.font = .Title1
//        }
        
        keywordCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(keywordLabel,
                         keywordCollectionView)
    }
    
    private func setLayout() {
        keywordLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        keywordCollectionView.snp.makeConstraints {
            $0.top.equalTo(keywordLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    //MARK: - Custom Method
    
    func updateCollectionViewHeight(height: CGFloat) {
        keywordCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
