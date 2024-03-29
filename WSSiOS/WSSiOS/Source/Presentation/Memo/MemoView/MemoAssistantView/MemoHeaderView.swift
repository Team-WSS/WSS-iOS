//
//  MemoHeaderView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then
import UIImageViewAlignedSwift

final class MemoHeaderView: UIView {
    
    //MARK: - Components
    
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    private let novelCoverImageView = UIImageViewAligned()
    
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
        
        novelTitleLabel.do {
            $0.textColor = .wssBlack
            $0.font = .Title1
        }
        
        novelAuthorLabel.do {
            $0.textColor = .wssGray200
            $0.font = .Body2
        }
        
        novelCoverImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
            $0.alignment = .top
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelTitleLabel,
                         novelAuthorLabel,
                         novelCoverImageView)
    }
    
    private func setLayout() {
        novelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(27)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(novelCoverImageView.snp.leading).offset(-18)
        }
        
        novelAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(novelCoverImageView.snp.leading).offset(-18)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        novelCoverImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(122)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(68)
            $0.height.equalTo(49)
        }
    }
    
    //MARK: - Data
    
    func bindData(novelTitle: String, novelAuthor: String, novelImage: String) {
        self.novelTitleLabel.do {
            $0.makeAttribute(with: novelTitle)?
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
        }
        self.novelAuthorLabel.do {
            $0.makeAttribute(with: novelAuthor)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
        }
        self.novelCoverImageView.kf.setImage(with: URL(string: novelImage))
    }
}
