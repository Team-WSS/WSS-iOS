//
//  HomeTasteRecommendSkeletonView.swift
//  WSSiOS
//
//  Created by Claude on 8/4/26.
//

import UIKit

import SnapKit
import Then

// 취향추천 카드(HomeTasteRecommendCollectionViewCell) 레이아웃을 흉내낸 스켈레톤.
// 2열 그리드로 카드 4개를 배치해 실제 컬렉션뷰가 채워졌을 때와 레이아웃 낙차가 없게 한다.
final class HomeTasteRecommendSkeletonView: UIView {

    //MARK: - UI Components

    private let columnStackView = UIStackView()
    private let leftColumnStackView = UIStackView()
    private let rightColumnStackView = UIStackView()
    private let cardViews = (0..<4).map { _ in HomeTasteRecommendSkeletonCardView() }

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
        columnStackView.do {
            $0.axis = .horizontal
            $0.spacing = 9
            $0.distribution = .fillEqually
        }

        [leftColumnStackView, rightColumnStackView].forEach {
            $0.axis = .vertical
            $0.spacing = 18
        }
    }

    private func setHierarchy() {
        self.addSubview(columnStackView)
        columnStackView.addArrangedSubviews(leftColumnStackView, rightColumnStackView)
        leftColumnStackView.addArrangedSubviews(cardViews[0], cardViews[1])
        rightColumnStackView.addArrangedSubviews(cardViews[2], cardViews[3])
    }

    private func setLayout() {
        columnStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: - Custom Method

    func startShimmering() {
        cardViews.forEach { $0.startShimmering() }
    }

    func stopShimmering() {
        cardViews.forEach { $0.stopShimmering() }
    }
}

private final class HomeTasteRecommendSkeletonCardView: UIView {

    private let imagePlaceholder = ShimmerView()
    private let titlePlaceholder = ShimmerView()
    private let authorPlaceholder = ShimmerView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        self.addSubviews(imagePlaceholder, titlePlaceholder, authorPlaceholder)

        imagePlaceholder.do {
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
        }
        imagePlaceholder.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(241)
        }

        titlePlaceholder.do {
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
        titlePlaceholder.snp.makeConstraints {
            $0.top.equalTo(imagePlaceholder.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(14)
        }

        authorPlaceholder.do {
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
        authorPlaceholder.snp.makeConstraints {
            $0.top.equalTo(titlePlaceholder.snp.bottom).offset(6)
            $0.leading.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(10)
            $0.bottom.equalToSuperview()
        }
    }

    func startShimmering() {
        [imagePlaceholder, titlePlaceholder, authorPlaceholder].forEach { $0.startShimmering() }
    }

    func stopShimmering() {
        [imagePlaceholder, titlePlaceholder, authorPlaceholder].forEach { $0.stopShimmering() }
    }
}
