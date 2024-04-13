//
//  TestView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/13/24.
//

import UIKit
import SnapKit

final class TestView: UIView {

    let keywordLink = KeywordLink()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white

        setUI()
        setHierarchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
    }

    private func setHierarchy() {
        addSubview(keywordLink)
    }

    private func setLayout() {
        keywordLink.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}