//
//  HomeAnnouncementTableViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/12/24.
//

import UIKit

import SnapKit
import Then

final class HomeAnnouncementTableViewCell: UITableViewCell {
    
    //MARK: - UI Components
    
    private var adminProfileImageView = UIImageView()
    private var titleLabel = UILabel()
    private var contentLabel = UILabel()
    private var dateLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        adminProfileImageView.do {
            $0.image = .imgTest2
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.font = .Title2
            $0.textColor = .wssBlack
            $0.makeAttribute(with: "#후회남에 등록된 새로운 웹소설을 확인해 보실 수 있습니다람쥐")?
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
        
        contentLabel.do {
            $0.font = .Body5
            $0.textColor = .wssGray200
            $0.makeAttribute(with: "후회남에 등록된 새로운 웹소설 리스트: <상수리 나무 아래>가 추가되었습니다~ 축하합니다~")?
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
        
        dateLabel.do {
            $0.font = .Body5
            $0.textColor = .wssGray200
            $0.text = "2024.10.03"
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(adminProfileImageView,
                         titleLabel,
                         contentLabel,
                         dateLabel)
    }
    
    private func setLayout() {
        adminProfileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
            $0.size.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(adminProfileImageView.snp.top)
            $0.leading.equalTo(adminProfileImageView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
    }
}
