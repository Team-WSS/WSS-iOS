//
//  NormalSearchResultView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchResultView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let novelResultLabel = UILabel()
    private let stackView = UIStackView()
    let normalSearchCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewLayout())
    private let normalSearchCollectionViewLayout = UICollectionViewFlowLayout()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        titleLabel.do {
            $0.fontTitle2Attribute(with: "작품")
            $0.textColor = .wssBlack
        }
        
        novelResultLabel.do {
            $0.fontBody4Attribute(with: "123")
            $0.textColor = .wssGray100
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
        }
        
        normalSearchCollectionView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        normalSearchCollectionViewLayout.do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 6
            $0.itemSize = CGSize(width: 335, height: 105)
            $0.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 40, right: 0)
            normalSearchCollectionView.setCollectionViewLayout($0, animated: false)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                        novelResultLabel,
                        normalSearchCollectionView)
    }
    
    private func setLayout() {
        normalSearchCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}
