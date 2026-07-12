//
//  LibraryFilterView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class LibraryFilterView: UIView {

    //MARK: - UI Components

    private let contentView = UIView()
    private let titleLabel = UILabel()
    let dismissButton = UIButton()
    let tabBarView = LibraryFilterTabBarView()
    private let chipsContainerStackView = UIStackView()
    let selectedChipsView = LibraryFilterSelectedChipsView()
    private let contentScrollView = UIScrollView()
    private let contentStackView = UIStackView()
    let readStatusView = LibraryFilterReadStatusView()
    let genreView = LibraryFilterGenreView()
    let publicationStatusView = LibraryFilterPublicationStatusView()
    let ratingView = LibraryFilterRatingView()
    let attractivePointView = LibraryFilterAttractivePointView()
    let keywordView = LibraryFilterKeywordView()
    let bottomActionView = WSSBottomActionView()

    //MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setHierarchy()
        setLayout()
        showTab(.readStatus)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        contentView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 16
            $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMaxXMinYCorner]
        }

        titleLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.MyLibrary.Filter.title)
            $0.textColor = .wssGray200
        }

        dismissButton.setImage(.icCancelModal.withTintColor(.wssGray300),
                               for: .normal)

        chipsContainerStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }

        contentScrollView.do {
            $0.showsVerticalScrollIndicator = false
        }

        contentStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }

    private func setHierarchy() {
        self.addSubview(contentView)
        contentView.addSubviews(titleLabel,
                                dismissButton,
                                tabBarView,
                                chipsContainerStackView,
                                contentScrollView,
                                bottomActionView)
        chipsContainerStackView.addArrangedSubview(selectedChipsView)
        contentScrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(readStatusView,
                                             genreView,
                                             publicationStatusView,
                                             ratingView,
                                             attractivePointView,
                                             keywordView)
    }

    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.isSE ? 481 : 516)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        dismissButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(65)
        }

        tabBarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview()
        }

        chipsContainerStackView.snp.makeConstraints {
            $0.top.equalTo(tabBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }

        contentScrollView.snp.makeConstraints {
            $0.top.equalTo(chipsContainerStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomActionView.snp.top)
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(contentScrollView.contentLayoutGuide)
            $0.width.equalTo(contentScrollView.frameLayoutGuide)
        }

        bottomActionView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
    }

    //MARK: - Custom Method

    func showTab(_ tab: LibraryFilterTab) {
        readStatusView.isHidden = tab != .readStatus
        genreView.isHidden = tab != .genre
        publicationStatusView.isHidden = tab != .publicationStatus
        ratingView.isHidden = tab != .rating
        attractivePointView.isHidden = tab != .attractivePoint
        keywordView.isHidden = tab != .keyword
    }

    func updateChips(_ chips: [LibraryFilterChip]) {
        selectedChipsView.update(chips)
        selectedChipsView.isHidden = chips.isEmpty

        UIView.performWithoutAnimation {
            self.layoutIfNeeded()
        }
    }
}
