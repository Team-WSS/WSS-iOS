//
//  NovelDetailInfoPlatformView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailInfoPlatformView: UIView {

    //MARK: - Components
    
    private let titleLabel = UILabel()
    let platformCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
        titleLabel.do {
            $0.makeAttribute(with: StringLiterals.NovelDetail.Info.platform)?
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.textColor = .wssBlack
            $0.font = .Title1
        }
        
        platformCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .wssWhite
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         platformCollectionView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        platformCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    //MARK: - Data
    
    func bindData(platformCount: Int) {
        if platformCount == 0 {
            self.removeFromSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateCollectionViewHeight(height: CGFloat) {
        platformCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }

}
