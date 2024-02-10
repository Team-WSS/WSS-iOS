//
//  NovelDetailCreateMemoView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailCreateMemoView: UIView {

    // MARK: - Components
    
    public let createMemoLabel = UILabel()
    private let createMemoImageView = UIImageView()

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

    // MARK: - UI
    
    private func setUI() {
        self.backgroundColor = .White
        
        createMemoLabel.do {
            $0.makeAttribute(with: "아직 작성된 메모가 없어요")?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -0.8)
                .applyAttribute()
            $0.textColor = .Gray200
            $0.font = .Body1
        }
        
        createMemoImageView.do {
            $0.image = ImageLiterals.icon.Memo.small
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
