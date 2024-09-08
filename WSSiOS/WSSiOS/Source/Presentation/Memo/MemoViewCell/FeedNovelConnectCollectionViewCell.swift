//
//  FeedNovelConnectCollectionViewCell.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/17/24.
//

import UIKit

import SnapKit
import Then

final class FeedNovelConnectCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            self.selectedImageView.image = isSelected ? .icSelectedNovel : .icDeselectedNovel
        }
    }
    
    //MARK: - Components
    
    private let coverImageView = UIImageView()
    private let labelWrapperView = UIView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let selectedImageView = UIImageView()
    
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
        coverImageView.do {
            $0.image = .imgLoadingThumbnail
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.textColor = .wssBlack
        }
        
        authorLabel.do {
            $0.textColor = .wssGray200
        }
        
        selectedImageView.do {
            $0.image = .icDeselectedNovel
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setHierarchy() {
        contentView.addSubviews(coverImageView,
                                labelWrapperView,
                                selectedImageView)
        labelWrapperView.addSubviews(titleLabel,
                                     authorLabel)
    }
    
    private func setLayout() {
        coverImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(78)
            $0.height.equalTo(105)
        }
        
        labelWrapperView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(coverImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(selectedImageView.snp.leading).offset(-16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        selectedImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
            $0.size.equalTo(24)
        }
    }
    
    //MARK: - Data
    
    func bindData(data: NormalSearchNovel) {
        self.coverImageView.kfSetImage(url: data.novelImage)
        
        self.titleLabel.do {
            $0.applyWSSFont(.title3, with: data.novelTitle)
        }
        
        self.authorLabel.do {
            $0.applyWSSFont(.body5, with: data.novelAuthor)
        }
    }
}
