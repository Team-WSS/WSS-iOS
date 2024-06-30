//
//  NovelInfoPlatformSection.swift
//  WSSiOS
//
//  Created by 이윤학 on 6/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoPlatformView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    let platformCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewLayout())
    private let platformCollectionViewLayout = UICollectionViewFlowLayout()
    
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
        
        titleLabel.do {
            $0.applyWSSFont(.title1,
                            with: StringLiterals.NovelDetail.Info.platform)
            $0.textColor = .wssBlack
        }
        
        platformCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 16
            $0.itemSize = CGSize(width: 48, height: 48)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            platformCollectionView.setCollectionViewLayout($0,
                                                           animated: false)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         platformCollectionView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(35)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        platformCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.bottom.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailInfoResult) {
        setDescriptionLabelText(with: data.novelDescription)
    }
    
    //MARK: - Custom Method
    
    func updateAccordionButton(_ isExpended: Bool) {
    }
    
    private func setDescriptionLabelText(with text: String) {
    }
}
