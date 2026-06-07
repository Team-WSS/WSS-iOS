//
//  NormalSearchPopularKeywordView.swift
//  WSSiOS
//
//  Created by onesunny2 on 6/8/26.
//

import UIKit

import SnapKit
import Then

final class NormalSearchPopularKeywordView: UIView {

    //MARK: - Components

    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()
    let headerButton = UIButton()
    let keywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

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
            $0.applyWSSFont(.title2, with: StringLiterals.Search.keywordSearchTitle)
            $0.textColor = .wssBlack
        }

        chevronImageView.do {
            $0.image = .icChevronRightMini
            $0.contentMode = .scaleAspectFit
        }

        keywordCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 6
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
        }
    }

    private func setHierarchy() {
        self.addSubviews(titleLabel, chevronImageView, headerButton, keywordCollectionView)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }

        chevronImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(3)
            $0.size.equalTo(16)
        }

        headerButton.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(titleLabel)
            $0.trailing.equalTo(chevronImageView)
        }

        keywordCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }

    //MARK: - Custom Methods

    func updateCollectionViewHeight(height: CGFloat) {
        keywordCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
