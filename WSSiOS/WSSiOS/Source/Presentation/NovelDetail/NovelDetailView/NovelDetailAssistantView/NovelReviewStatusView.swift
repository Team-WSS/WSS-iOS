//
//  NovelReviewStatusView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import SnapKit
import Then

final class NovelReviewStatusView: UIView {
    
    //MARK: - Components
    
    let statusCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let dateButton = UIButton()
    
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
        
        statusCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: 105, height: 78)

            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
        }
        
        dateButton.do {
            $0.setButtonUnderlinedAttributedTitle(text: StringLiterals.NovelReview.Date.addDate, font: .Body4_2, color: .wssGray200)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(statusCollectionView,
                         dateButton)
    }
    
    private func setLayout() {
        statusCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(45)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(78)
        }
        
        dateButton.snp.makeConstraints {
            $0.top.equalTo(statusCollectionView.snp.bottom).offset(17.5)
            $0.bottom.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
    }
}
