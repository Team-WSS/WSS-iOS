//
//  NovelDetailFeedEmptyView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailFeedEmptyView: UIView {
    
    //MARK: - Components
    
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    
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
            $0.image = .imgEmptyCatEyes
            $0.contentMode = .scaleAspectFit
        }
        
        descriptionLabel.do {
            $0.applyWSSFont(.body2, with: StringLiterals.NovelDetail.Feed.emptyDescription)
            $0.textColor = .wssGray200
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(imageView,
                         descriptionLabel)
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(40)
            $0.width.equalTo(166)
            $0.height.equalTo(160)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(11)
            $0.bottom.equalToSuperview().inset(70)
        }
    }
}
