//
//  NovelReviewAttractivePointView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/13/24.
//

import UIKit

import SnapKit
import Then

enum AttractivePoints: CaseIterable {
    case worldview, material, character, relationship, vibe
    
    var koreanString: String {
        switch self {
        case .worldview: "세계관"
        case .material: "소재"
        case .character: "캐릭터"
        case .relationship: "관계"
        case .vibe: "분위기"
        }
    }
}

final class NovelReviewAttractivePointView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    let attractivePointCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
            $0.backgroundColor = .white
        }
        
        titleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.NovelReview.AttractivePoint.attractivePoint)
            $0.textColor = .wssBlack
        }
        
        attractivePointCollectionView.do {
            let layout = CenterAlignedCollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 6

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.allowsMultipleSelection = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel, 
                         attractivePointCollectionView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(25)
        }
        
        attractivePointCollectionView.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(32)
            $0.height.equalTo(37)
        }
    }
}
