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
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        titleLabel.do {
            $0.fontTitle2Attribute(with: StringLiterals.Search.novel)
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
            $0.isScrollEnabled = false
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
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        stackView.addArrangedSubviews(titleLabel,
                                      novelResultLabel)
        contentView.addSubviews(stackView,
                                normalSearchCollectionView)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide).inset(10)
            $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        normalSearchCollectionView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
}
