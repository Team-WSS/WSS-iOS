//
//  TrashNovelDetailCreateMemoView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class TrashNovelDetailCreateMemoView: UIView {

    //MARK: - Components
    
    let createMemoLabel = UILabel()
    private let createMemoImageView = UIImageView()

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

    //MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .wssWhite
        
        createMemoLabel.do {
            $0.makeAttribute(with: StringLiterals.NovelDetail.Memo.noMemo)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -0.8)
                .applyAttribute()
            $0.textColor = .wssGray200
            $0.font = .Body1
        }
        
        createMemoImageView.do {
            $0.image = .icCreateMemoSmall
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(createMemoLabel,
                         createMemoImageView)
    }
    
    private func setLayout() {
        createMemoLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        createMemoImageView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(38)
            $0.size.equalTo(24)
        }
    }
}
