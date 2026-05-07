//
//  NormalSearchGenreView.swift
//  WSSiOS
//
//  Created by onesunny2 on 5/8/25.
//

import UIKit

import SnapKit
import Then

final class NormalSearchGenreView: UIView {

    //MARK: - Components

    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()
    let headerButton = UIButton()
    let genreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

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
            $0.applyWSSFont(.title2, with: StringLiterals.Search.genreSearchTitle)
            $0.textColor = .wssBlack
        }

        chevronImageView.do {
            $0.image = .icChevronRightMini
            $0.contentMode = .scaleAspectFit
        }

        genreCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
        }
    }

    private func setHierarchy() {
        self.addSubviews(titleLabel, chevronImageView, headerButton, genreCollectionView)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
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

        genreCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(69)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}
