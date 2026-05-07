//
//  NormalSearchRecentTagCell.swift
//  WSSiOS
//
//  Created by onesunny2 on 5/6/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class NormalSearchRecentTagCell: UICollectionViewCell {

    //MARK: - Properties

    var deleteAction: (() -> Void)?
    private var disposeBag = DisposeBag()

    //MARK: - Components

    private let keywordLabel = UILabel()
    private let deleteButton = UIButton()
    private let contentStackView = UIStackView()

    //MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setHierarchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        deleteAction = nil
        disposeBag = DisposeBag()
    }

    //MARK: - UI

    private func setUI() {
        self.contentView.do {
            $0.layer.cornerRadius = 17.5
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.wssPrimary100.cgColor
            $0.backgroundColor = .wssWhite
        }

        contentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
        }

        keywordLabel.do {
            $0.textColor = .wssPrimary100
        }

        deleteButton.do {
            $0.setImage(.icKeywordCancel, for: .normal)
            $0.isUserInteractionEnabled = true
        }
    }

    private func setHierarchy() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(keywordLabel, deleteButton)
    }

    private func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(13)
            $0.centerY.equalToSuperview()
        }

        deleteButton.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }

    //MARK: - Data

    func bindData(keyword: String) {
        keywordLabel.applyWSSFont(.body2, with: keyword)

        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.deleteAction?()
            })
            .disposed(by: disposeBag)
    }
}
