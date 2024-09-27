//
//  NovelKeywordSelectEmptyView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelKeywordSelectEmptyView: UIView {
    
    //MARK: - Components
    
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    let contactButton = UILabel()
    private let contactLabel = UILabel()
    
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
        imageView.do {
            $0.image = .imgEmpty
            $0.contentMode = .scaleAspectFit
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body1, with: StringLiterals.NovelReview.KeywordSearch.unregisteredKeyword)
            $0.textColor = .wssGray200
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        contactButton.do {
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
            $0.backgroundColor = .wssPrimary50
        }
        
        contactLabel.do {
            $0.applyWSSFont(.title2, with: StringLiterals.NovelReview.KeywordSearch.contact)
            $0.textColor = .wssPrimary100
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(imageView,
                         descriptionLabel,
                         contactButton)
        contactButton.addSubviews(contactLabel)
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.centerX.top.equalToSuperview()
            $0.width.equalTo(39)
            $0.height.equalTo(48)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(8)
        }
        
        contactButton.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            $0.width.equalTo(195)
            $0.height.equalTo(58)
            
            contactLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}
