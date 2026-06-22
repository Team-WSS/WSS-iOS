//
//  LibraryFilterRatingView.swift
//  WSSiOS
//
//  Created by YunhakLee on 5/26/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class LibraryFilterRatingView: UIView {

    //MARK: - UI Components

    let rangeSlider = WSSRangeSlider()
    private let minBackgroundView = UIView()
    private let minLabel = UILabel()
    private let maxBackgroundView = UIView()
    private let maxLabel = UILabel()
    private let notRatedLabel = UILabel()
    private let notRatedToggleButton = WSSToggleButton()

    //MARK: - Observable

    var ratingChanged: Observable<(CGFloat, CGFloat)> {
        return rangeSlider.rx.controlEvent(.valueChanged)
            .map { [weak rangeSlider] _ in
                return (rangeSlider?.lowerValue ?? 0.0,
                        rangeSlider?.upperValue ?? 5.0)
            }
    }

    var notRatedTapped: Observable<Void> {
        return notRatedToggleButton.rx.tap.asObservable()
    }

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
        rangeSlider.do {
            $0.minimumValue = 0.0
            $0.maximumValue = 5.0
            $0.step = 0.5
            $0.setValues(lower: 0.0, upper: 5.0)
        }

        [minBackgroundView,
         maxBackgroundView].forEach {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 8
        }

        minLabel.do {
            $0.applyWSSFont(.body2, with: "0.0")
            $0.textColor = .wssPrimary100
        }

        maxLabel.do {
            $0.applyWSSFont(.body2, with: "5.0")
            $0.textColor = .wssPrimary100
        }

        notRatedLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.MyLibrary.Filter.notRatedOnly)
            $0.textColor = .wssGray300
        }

        notRatedToggleButton.do {
            $0.updateToggle(false)
        }
    }

    private func setHierarchy() {
        minBackgroundView.addSubview(minLabel)
        maxBackgroundView.addSubview(maxLabel)

        self.addSubviews(minBackgroundView,
                         rangeSlider,
                         maxBackgroundView,
                         notRatedLabel,
                         notRatedToggleButton)
    }

    private func setLayout() {
        minBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(50)
            $0.height.equalTo(38)
        }

        minLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        rangeSlider.snp.makeConstraints {
            $0.centerY.equalTo(minLabel)
            $0.leading.equalTo(minBackgroundView.snp.trailing).offset(17)
            $0.trailing.equalTo(maxBackgroundView.snp.leading).offset(-17)
            $0.height.equalTo(16)
        }

        maxBackgroundView.snp.makeConstraints {
            $0.top.equalTo(minBackgroundView.snp.top)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(50)
            $0.height.equalTo(38)
        }

        maxLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        notRatedLabel.snp.makeConstraints {
            $0.top.equalTo(minBackgroundView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().inset(20)
        }

        notRatedToggleButton.snp.makeConstraints {
            $0.centerY.equalTo(notRatedLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }

    //MARK: - Custom Method

    func setValues(lower: CGFloat, upper: CGFloat) {
        rangeSlider.setValues(lower: lower, upper: upper)
        updateRatingLabels(lower: lower, upper: upper)
    }

    func updateRatingLabels(lower: CGFloat, upper: CGFloat) {
        minLabel.applyWSSFont(.body2, with: String(format: "%.1f", lower))
        maxLabel.applyWSSFont(.body2, with: String(format: "%.1f", upper))
    }

    func setNotRated(_ isOn: Bool) {
        notRatedToggleButton.updateToggle(isOn)
        rangeSlider.setEnabled(!isOn)

        if isOn {
            rangeSlider.setValues(lower: 0.0, upper: 5.0)
            updateRatingLabels(lower: 0.0, upper: 5.0)
            minLabel.textColor = .wssGray200
            maxLabel.textColor = .wssGray200
        } else {
            minLabel.textColor = .wssPrimary100
            maxLabel.textColor = .wssPrimary100
        }
    }
}
