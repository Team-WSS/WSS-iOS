//
//  MyPageNovelPreferencesView.swift
//  WSSiOS
//
//  Created by 신지원 on 11/16/24.
//

import UIKit

import SnapKit
import Then

final class MyPageNovelPreferencesView: UIView {

    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let preferencesView = UIView()
    private let preferencesLabel = UILabel()
    
    lazy var preferencesCollectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewLayout())
    
    
    // MARK: - Life Cycle
    
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
        self.backgroundColor = .wssWhite
        
        titleLabel.do {
            $0.applyWSSFont(.title1, with: StringLiterals.MyPage.Profile.novelPreferenceTitle)
            $0.textColor = .wssBlack
        }
        
        preferencesView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
        }
        
        preferencesCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 6
            layout.minimumInteritemSpacing = 6
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            
            $0.backgroundColor = .wssWhite
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.allowsMultipleSelection = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         preferencesView,
                         preferencesCollectionView)
        preferencesView.addSubviews(preferencesLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(20)
        }
        
        preferencesView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(55)
            
            preferencesLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        preferencesCollectionView.snp.makeConstraints {
            $0.top.equalTo(preferencesView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    //MARK: - Data
    
    func bindData(data: [String]) {
        let koreanStrings = data.compactMap { AttractivePoint(rawValue: $0)?.koreanString }
        let attaractiveString = koreanStrings.joined(separator: ", ")
        preferencesLabel.do {
            $0.font = .Title3
            $0.textColor = .wssGray300
            $0.makeAttribute(with: attaractiveString + StringLiterals.MyPage.Profile.novelPreferenceLabel)?
                .lineHeight(1.5)
                .kerning(kerningPixel: -0.6)
                .partialColor(color: .wssPrimary100, rangeString: attaractiveString)
                .applyAttribute()
        }
    }
}


