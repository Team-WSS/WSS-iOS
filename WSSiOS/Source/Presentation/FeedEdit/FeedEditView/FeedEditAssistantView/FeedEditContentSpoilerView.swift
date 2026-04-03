//
//  FeedEditContentSpoilerView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/9/25.
//

import UIKit

import SnapKit
import Then

final class FeedEditContentSpoilerView: UIView {
    
    //MARK: - Components
    
    private let spoilerNoticeLabel = UILabel()
    var spoilerButton = WSSToggleButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.layer.borderWidth = 1
        }
        
        spoilerNoticeLabel.do {
            $0.applyWSSFont(.body3, with: StringLiterals.FeedEdit.spoilrSetting)
            $0.makeAttribute(with: StringLiterals.FeedEdit.spoilrSetting)?
                .lineHeight(WSSFont.body3.lineHeightMultiple)
                .kerning(kerningPixel: WSSFont.body3.kerningPixel)
                .partialFont(font: UIFont(name: "Pretendard-SemiBold", size: 14)!, rangeString: "스포일러")
                .applyAttribute()
            $0.textColor = .wssGray200
        }
        
        spoilerButton.do {
            $0.setToggleSize(
                toggleSize: CGSize(width: 42, height: 42),
                barViewSize: CGSize(width: 40, height: 22),
                circleViewSize: CGSize(width: 18, height: 18),
                onCircleInset: 2
            )
        }
    }
    
    private func setHierachy() {
        self.addSubviews(spoilerNoticeLabel,
                         spoilerButton)
    }
    
    private func setLayout() {
        spoilerNoticeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        spoilerButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
