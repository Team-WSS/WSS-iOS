//
//  NormalSearchRecentView.swift
//  WSSiOS
//
//  Created by onesunny2 on 5/6/25.
//

import UIKit

import SnapKit
import Then

final class NormalSearchRecentView: UIView {

    //MARK: - Components

    private let titleLabel = UILabel()
    let deleteAllButton = UIButton()
    let recentTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

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
            $0.applyWSSFont(.title2, with: StringLiterals.Search.recentSearchTitle)
            $0.textColor = .wssBlack
        }

        deleteAllButton.do {
            $0.setTitle(StringLiterals.Search.deleteAll, for: .normal)
            $0.setTitleColor(.wssGray200, for: .normal)
            $0.titleLabel?.font = .Body4
        }

        recentTagCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
        }
    }

    private func setHierarchy() {
        self.addSubviews(titleLabel, deleteAllButton, recentTagCollectionView)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(20)
        }

        deleteAllButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }

        recentTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}
