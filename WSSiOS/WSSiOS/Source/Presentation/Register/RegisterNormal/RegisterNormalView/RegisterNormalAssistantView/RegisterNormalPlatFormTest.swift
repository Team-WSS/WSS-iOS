//
//  RegisterNormalPlatFormTest.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/17/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalPlatFormTest: UIView {
    
    //MARK: - set Properties

    public var platformList: [UserNovelPlatform] = []

    // MARK: - UI Components
    
    private let titleLabel = WSSSectionTitleView()
    public let platformCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set UI
    
    private func setUI() {
        titleLabel.do {
            $0.setText("작품 보러가기")
        }
        
        platformCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
        }
    }
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(titleLabel,
                         platformCollectionView)
    }
    
    // MARK: - set Layout
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.leading.trailing.equalToSuperview()
        }
        
        platformCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    func updateCollectionViewHeight(height: CGFloat) {
        platformCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    func bindData(platforms: [UserNovelPlatform]) {
        self.platformList = platforms
        
        if self.platformList.count == 0 {
            self.removeFromSuperview()
        }
        print(platforms)
    }
}
