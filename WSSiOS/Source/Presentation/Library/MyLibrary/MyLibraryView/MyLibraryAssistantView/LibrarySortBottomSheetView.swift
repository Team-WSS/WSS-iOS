//
//  LibrarySortBottomSheetView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/22/26.
//

import UIKit

import SnapKit
import Then

final class LibrarySortBottomSheetView: UIView {

    //MARK: - Components

    let backgroundButton = UIButton()
    private let sheetView = UIView()
    private let titleLabel = UILabel()
    private let rowsStackView = UIStackView()
    let sortRowButtons: [LibrarySortRowButton]

    //MARK: - Life Cycle

    init(currentSort: LibrarySortType) {
        self.sortRowButtons = LibrarySortType.allCases.map { LibrarySortRowButton($0) }

        super.init(frame: .zero)

        setUI()
        setHierarchy()
        setLayout()
        updateSelection(currentSort)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UI

    private func setUI() {
        self.backgroundColor = .clear

        sheetView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }

        titleLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.MyLibrary.Sort.title)
            $0.textColor = .wssBlack
        }

        rowsStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }

    private func setHierarchy() {
        self.addSubviews(backgroundButton,
                         sheetView)
        sheetView.addSubviews(titleLabel,
                              rowsStackView)
        sortRowButtons.forEach {
            rowsStackView.addArrangedSubview($0)
        }
    }

    private func setLayout() {
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        sheetView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
        }

        rowsStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
        }
    }

    //MARK: - Custom Method

    func updateSelection(_ sort: LibrarySortType) {
        sortRowButtons.forEach {
            $0.setSelected($0.sortType == sort)
        }
    }
}

//MARK: - Row Button

final class LibrarySortRowButton: UIButton {

    let sortType: LibrarySortType

    private let sortTitleLabel = UILabel()
    private let checkImageView = UIImageView()

    init(_ sortType: LibrarySortType) {
        self.sortType = sortType

        super.init(frame: .zero)

        setUI()
        setHierarchy()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        sortTitleLabel.do {
            $0.applyWSSFont(.body2, with: sortType.text)
            $0.textColor = .wssGray300
            $0.isUserInteractionEnabled = false
        }

        checkImageView.do {
            $0.image = .icCheck
            $0.isHidden = true
            $0.isUserInteractionEnabled = false
        }
    }

    private func setHierarchy() {
        self.addSubviews(sortTitleLabel,
                         checkImageView)
    }

    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(52)
        }

        sortTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }

        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(20)
        }
    }

    func setSelected(_ isSelected: Bool) {
        sortTitleLabel.textColor = isSelected ? .wssBlack : .wssGray300
        checkImageView.isHidden = !isSelected
    }
}
