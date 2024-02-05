//
//  SearchCollectionViewCell.swift
//  WSSiOS
//
//  Created by 최서연 on 1/7/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class SearchCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "SearchCollectionViewCell"
    
    //MARK: - Components
    
    private let novelImageView = UIImageView()
    private let novelStackView = UIStackView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    private let novelGenreLabel = UILabel()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        novelImageView.do {
            $0.layer.cornerRadius = 6
            $0.clipsToBounds = true
        }
        
        novelStackView.do {
            $0.axis = .vertical
            $0.spacing = 2
            $0.alignment = .leading
        }
        
        novelTitleLabel.do {
            $0.font = .Title2
            $0.textColor = .wssBlack
        }
        
        novelAuthorLabel.do {
            $0.font = .Label1
            $0.textColor = .wssGray200
        }
        
        novelGenreLabel.do {
            $0.font = .Label1
            $0.textColor = .wssGray200
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(novelImageView,
                         novelStackView)
        
        novelStackView.addArrangedSubviews(novelTitleLabel,
                                           novelAuthorLabel,
                                           novelGenreLabel)
    }

    private func setLayout() {
        novelImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(76)
            $0.height.equalTo(104)
        }
        
        novelStackView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalTo(novelImageView.snp.trailing).offset(16)
        }
    }
    
    //MARK: - Data
    
    func bindData(data: SearchNovel) {
        guard let imageURL = URL(string: data.novelImg) else { return }
        novelImageView.kf.setImage(with: imageURL)
        
        novelTitleLabel.do {
            $0.makeAttribute(with: data.novelTitle)?
                .kerning(kerningPixel: -0.6)
                .lineSpacing(spacingPercentage: 140)
                .applyAttribute()
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        novelAuthorLabel.do {
            $0.makeAttribute(with: data.novelAuthor)?
                .kerning(kerningPixel: 0)
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        novelGenreLabel.do {
            $0.makeAttribute(with: data.novelGenre)?
                .kerning(kerningPixel: 0)
                .lineSpacing(spacingPercentage: 145)
                .applyAttribute()
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
}
