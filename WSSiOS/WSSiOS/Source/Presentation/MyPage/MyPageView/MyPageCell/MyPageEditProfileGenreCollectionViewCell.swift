//
//  MyPageEditProfileGenreCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 7/26/24.
//

import UIKit

import SnapKit
import Then

final class MyPageEditProfileGenreCollectionViewCell: UICollectionViewCell {

    //MARK: - Life Cycle

    private let genreKeywordView = KeywordViewManager.shared.link()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setHierarchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UI

    private func setHierarchy() {
        self.addSubview(genreKeywordView)
    }

    private func setLayout() {
        genreKeywordView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: - Data

    func bindData(genre: String, isSelected: Bool) {
        genreKeywordView.do {
            $0.setText(genre)
            $0.updateColor(isSelected)
        }
    }
}
