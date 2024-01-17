//
//  HomeSosoPickCollectionViewCell.swift
//  WSSiOS
//
//  Created by 최서연 on 1/11/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class HomeSosoPickCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "HomeSosoPickCollectionViewCell"
    
    //MARK: - UI Components
    
    private let bottomBackgroundView = UIView()
    private let novelImageShadowView = UIView()
    private let novelImageView = UIImageView()
    private let novelStackView = UIStackView()
    private let novelUserNumberView = HomeSosoPickUserNumberChipView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - set UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .Primary80
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = false
            $0.layer.shadowPath = UIBezierPath(roundedRect: $0.bounds, cornerRadius: $0.layer.cornerRadius).cgPath
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 15
        }
        
        novelImageShadowView.do {
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 15
        }
        
        bottomBackgroundView.do {
            $0.backgroundColor = .White
            $0.layer.cornerRadius = 12
            $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        novelImageView.do {
            $0.layer.cornerRadius = 6
            $0.clipsToBounds = true
        }
        
        novelStackView.do {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.spacing = 2
        }
        
        novelTitleLabel.do {
            $0.font = .Title2
            $0.textColor = .Black
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        novelAuthorLabel.do {
            $0.font = .Body3
            $0.textColor = .Gray200
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(novelImageShadowView,
                         bottomBackgroundView)
        novelImageShadowView.addSubview(novelImageView)
        bottomBackgroundView.addSubviews(novelUserNumberView,
                                         novelStackView)
        novelStackView.addArrangedSubviews(novelTitleLabel,
                                           novelAuthorLabel)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        novelImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.leading.equalToSuperview().inset(83)
            $0.width.equalTo(64)
            $0.height.equalTo(93)
        }
        
        bottomBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(101)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        novelUserNumberView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
        }
        
        novelStackView.snp.makeConstraints {
            $0.top.equalTo(novelUserNumberView.snp.bottom).offset(7)
            $0.leading.equalTo(novelUserNumberView.snp.leading)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    //MARK: - bind Data
    
    func bindData(data: SosopickNovel) {
        guard let imageUrl = URL(string: data.novelImage) else { return }
        novelImageView.kf.setImage(with: imageUrl)
        
        novelUserNumberView.userNumberLabel.do {
            $0.makeAttribute(with: "\(data.novelRegisteredCount)명이 등록")?
                .kerning(kerningPixel: 0)
                .lineSpacing(spacingPercentage: 100)
                .applyAttribute()
        }
        
        novelTitleLabel.do {
            $0.makeAttribute(with: data.novelTitle)?
                .kerning(kerningPixel: -0.6)
                .lineSpacing(spacingPercentage: 140)
                .applyAttribute()
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        novelAuthorLabel.do {
            $0.makeAttribute(with: data.novelAuthor)?
                .kerning(kerningPixel: 0)
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
}


