//
//  LibraryFilterSelectedChipCell.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterSelectedChipCell: UICollectionViewCell {

    //MARK: - Properties

    static let identifier = "LibraryFilterSelectedChipCell"

    //MARK: - UI Components

    private let keywordTag = KeywordTag()

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

    private func setUI() {
        self.do {
            $0.backgroundColor = .clear
        }

        keywordTag.do {
            $0.setBackgroundColor(.wssWhite)
        }
    }

    private func setHierarchy() {
        contentView.addSubview(keywordTag)
    }

    private func setLayout() {
        keywordTag.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: - Custom Method

    func configure(title: String) {
        keywordTag.setText(title)
    }
}
