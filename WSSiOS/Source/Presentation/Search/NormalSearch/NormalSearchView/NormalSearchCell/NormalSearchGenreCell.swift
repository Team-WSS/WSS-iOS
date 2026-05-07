//
//  NormalSearchGenreCell.swift
//  WSSiOS
//
//  Created by onesunny2 on 5/8/25.
//

import UIKit

import SnapKit
import Then

final class NormalSearchGenreCell: UICollectionViewCell {

    //MARK: - Components

    private let circleImageView = UIImageView()
    private let genreIconImageView = UIImageView()
    private let genreLabel = UILabel()

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
        circleImageView.do {
            $0.image = .icGenreBackground
        }

        genreLabel.do {
            $0.textColor = .wssGray300
            $0.textAlignment = .center
        }
    }

    private func setHierarchy() {
        contentView.addSubviews(circleImageView, genreIconImageView, genreLabel)
    }

    private func setLayout() {
        circleImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(44)
        }

        genreIconImageView.snp.makeConstraints {
            $0.center.equalTo(circleImageView)
            $0.size.equalTo(32)
        }

        genreLabel.snp.makeConstraints {
            $0.top.equalTo(circleImageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }

    //MARK: - Data

    func bindData(genre: NovelGenre) {
        genreIconImageView.image = genre.image
        genreLabel.applyWSSFont(.body3, with: genre.withKorean)
    }
}
