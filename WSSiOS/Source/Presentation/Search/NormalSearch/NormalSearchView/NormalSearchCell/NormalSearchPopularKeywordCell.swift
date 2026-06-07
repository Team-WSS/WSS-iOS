//
//  NormalSearchPopularKeywordCell.swift
//  WSSiOS
//
//  Created by onesunny2 on 6/8/26.
//

import UIKit

import SnapKit
import Then

final class NormalSearchPopularKeywordCell: UICollectionViewCell {

    //MARK: - Components

    private let keywordLabel = UILabel()

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
        contentView.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }

        keywordLabel.do {
            $0.textColor = .wssGray300
        }
    }

    private func setHierarchy() {
        contentView.addSubview(keywordLabel)
    }

    private func setLayout() {
        keywordLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.leading.trailing.equalToSuperview().inset(13)
        }
    }

    //MARK: - Data

    func bindData(keyword: KeywordData) {
        keywordLabel.applyWSSFont(.body3, with: keyword.keywordName)
    }
}
