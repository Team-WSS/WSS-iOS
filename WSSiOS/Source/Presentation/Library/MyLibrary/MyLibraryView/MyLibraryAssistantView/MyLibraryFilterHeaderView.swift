//
//  MyLibraryFilterHeaderView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/25/25.
//


import UIKit

import SnapKit
import Then

final class MyLibraryFilterHeaderView: UIView {

    //MARK: - Components

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    let interestFilterButton = WSSFilterButton()
    private let dividerView = UIView()
    let readStatusFilterButton = WSSFilterButton()
    let genreFilterButton = WSSFilterButton()
    let publicationStatusFilterButton = WSSFilterButton()
    let starRatingFilterButton = WSSFilterButton()
    let attractivePointFilterButton = WSSFilterButton()
    let keywordFilterButton = WSSFilterButton()

    // MARK: - Life Cycle

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
        self.backgroundColor = .wssWhite

        scrollView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }

        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
        }

        interestFilterButton.do {
            $0.setImageHidden(isHidden: true)
            $0.setButtonText(StringLiterals.MyLibrary.FilterButton.interest)
        }

        dividerView.do {
            $0.backgroundColor = .wssGray80
        }

        readStatusFilterButton.do {
            $0.setImageHidden(isHidden: false)
            $0.setButtonText(StringLiterals.MyLibrary.FilterButton.readStatus)
        }

        genreFilterButton.do {
            $0.setImageHidden(isHidden: false)
            $0.setButtonText(StringLiterals.MyLibrary.FilterButton.genre)
        }

        publicationStatusFilterButton.do {
            $0.setImageHidden(isHidden: false)
            $0.setButtonText(StringLiterals.MyLibrary.FilterButton.publicationStatus)
        }

        starRatingFilterButton.do {
            $0.setImageHidden(isHidden: false)
            $0.setButtonText(StringLiterals.MyLibrary.FilterButton.starRating)
        }

        attractivePointFilterButton.do {
            $0.setImageHidden(isHidden: false)
            $0.setButtonText(StringLiterals.MyLibrary.FilterButton.attractivePoint)
        }

        keywordFilterButton.do {
            $0.setImageHidden(isHidden: false)
            $0.setButtonText(StringLiterals.MyLibrary.FilterButton.keyword)
        }
    }

    private func setHierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews(interestFilterButton,
                                      dividerView,
                                      readStatusFilterButton,
                                      genreFilterButton,
                                      publicationStatusFilterButton,
                                      starRatingFilterButton,
                                      attractivePointFilterButton,
                                      keywordFilterButton)
    }

    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(57)
        }

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }

        stackView.do {
            $0.spacing = 6
            $0.setCustomSpacing(10, after: interestFilterButton)
            $0.setCustomSpacing(10, after: dividerView)
        }

        dividerView.snp.makeConstraints {
            $0.height.equalTo(33)
            $0.width.equalTo(1)
        }
    }

    //MARK: - Update

    func updateFilterButtons(selectedOption: LibraryFilterOption) {
        interestFilterButton.updateButton(isSelected: selectedOption.interestedOption)
        updateReadStatusFilterButton(selectedOption.readStatusOptions)
        updateGenreFilterButton(selectedOption.genreOptions)
        updatePublicationStatusFilterButton(selectedOption.publicationStatusOptions)
        updateRatingFilterButton(min: selectedOption.minimumStarRateOption,
                                 max: selectedOption.maximumStarRateOption,
                                 notRated: selectedOption.notStarRatedOption)
        updateAttractivePointFilterButton(selectedOption.attractivePointOptions)
        updateKeywordFilterButton(selectedOption.keywordOptions)
    }

    private func updateReadStatusFilterButton(_ options: [ReadStatus]) {
        apply(to: readStatusFilterButton,
              items: options,
              defaultText: StringLiterals.MyLibrary.FilterButton.readStatus,
              name: { $0.statusName })
    }

    private func updateGenreFilterButton(_ options: [NovelGenre]) {
        apply(to: genreFilterButton,
              items: options,
              defaultText: StringLiterals.MyLibrary.FilterButton.genre,
              name: { $0.withKorean })
    }

    private func updatePublicationStatusFilterButton(_ options: [PublicationStatus]) {
        apply(to: publicationStatusFilterButton,
              items: options,
              defaultText: StringLiterals.MyLibrary.FilterButton.publicationStatus,
              name: { $0.description })
    }

    private func updateAttractivePointFilterButton(_ options: [AttractivePoint]) {
        apply(to: attractivePointFilterButton,
              items: options,
              defaultText: StringLiterals.MyLibrary.FilterButton.attractivePoint,
              name: { $0.koreanString })
    }

    private func updateKeywordFilterButton(_ options: [KeywordData]) {
        apply(to: keywordFilterButton,
              items: options,
              defaultText: StringLiterals.MyLibrary.FilterButton.keyword,
              name: { $0.keywordName })
    }

    private func updateRatingFilterButton(min: CGFloat, max: CGFloat, notRated: Bool) {
        let isSelected = notRated || min != 0.0 || max != 5.0
        let text: String
        if notRated {
            text = StringLiterals.MyLibrary.FilterButton.ratingEmpty
        } else if min != 0.0 || max != 5.0 {
            text = "\(String(format: "%.1f", min))~\(String(format: "%.1f", max))"
        } else {
            text = StringLiterals.MyLibrary.FilterButton.starRating
        }

        starRatingFilterButton.do {
            $0.setButtonText(text)
            $0.updateButton(isSelected: isSelected)
        }
    }

    /// 리스트형 칩 공통 처리: 0개=기본 라벨, 1개=값명, 2개 이상="첫값 외 n"
    private func apply<T>(to button: WSSFilterButton,
                          items: [T],
                          defaultText: String,
                          name: (T) -> String) {
        let isSelected = !items.isEmpty
        let text: String
        if let first = items.first {
            text = items.count > 1 ? "\(name(first)) 외 \(items.count - 1)" : name(first)
        } else {
            text = defaultText
        }

        button.do {
            $0.setButtonText(text)
            $0.updateButton(isSelected: isSelected)
        }
    }
}
