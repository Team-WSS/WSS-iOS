//
//  WSSBottomActionView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import UIKit

import SnapKit
import Then

final class WSSBottomActionView: UIView {

    //MARK: - UI Components

    let resetButton = UIButton()
    private let resetContentStackView = UIStackView()
    private let resetImageView = UIImageView()
    private let resetLabel = UILabel()

    let searchButton = UIButton()
    private let searchLabel = UILabel()
    
    private let searchButtonTitle: String

    //MARK: - Life Cycle

    init(searchButtonTitle: String = StringLiterals.DetailSearch.searchNovel) {
        self.searchButtonTitle = searchButtonTitle
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
        resetButton.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.wssGray80.cgColor
            $0.clipsToBounds = true
        }

        resetContentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
            $0.isUserInteractionEnabled = false
        }

        resetImageView.do {
            $0.image = .icReload.withRenderingMode(.alwaysOriginal).withTintColor(.wssGray200)
            $0.contentMode = .scaleAspectFit
        }

        resetLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.DetailSearch.reload)
            $0.textColor = .wssGray200
        }

        searchButton.do {
            $0.backgroundColor = .wssPrimary100
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }

        searchLabel.do {
            $0.applyWSSFont(.title2, with: searchButtonTitle)
            $0.textColor = .wssWhite
            $0.isUserInteractionEnabled = false
        }
    }

    private func setHierarchy() {
        resetContentStackView.addArrangedSubviews(resetImageView,
                                                  resetLabel)
        resetButton.addSubview(resetContentStackView)
        searchButton.addSubview(searchLabel)
        self.addSubviews(resetButton,
                         searchButton)
    }

    private func setLayout() {
        resetButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(95)
            $0.height.equalTo(53)
        }

        resetContentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        resetImageView.snp.makeConstraints {
            $0.size.equalTo(14)
        }

        searchButton.snp.makeConstraints {
            $0.top.bottom.equalTo(resetButton)
            $0.leading.equalTo(resetButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(16)
        }

        searchLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    //MARK: - Custom Method

    func updateSearchButtonTitle(_ title: String) {
        searchLabel.applyWSSFont(.title2, with: title)
    }
}
