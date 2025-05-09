//
//  FeedListImageView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/9/25.
//

import UIKit

import SnapKit
import Then

final class FeedListImageView: UIView {
    
    //MARK: - Components
    
    private let thumbnailImageView = UIImageView()
    private let imageCountBackgroundView = UIView()
    private let imageCountLabel = UILabel()
    
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
    
    private func setUI() {
        thumbnailImageView.do {
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.image = .test
        }
        
        imageCountBackgroundView.do {
            $0.backgroundColor = .wssGrayToast
            $0.clipsToBounds = true
            $0.layoutMargins = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        }
        
        imageCountLabel.do {
            $0.textColor = .wssWhite
            $0.applyWSSFont(.body5, with: "20")
        }
    }
    
    private func setHierarchy() {
        self.addSubview(thumbnailImageView)
        
        thumbnailImageView.addSubview(imageCountBackgroundView)
        imageCountBackgroundView.addSubview(imageCountLabel)
    }
    
    private func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(160)
            
            imageCountBackgroundView.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(12)
                $0.bottom.equalToSuperview().inset(10)
                $0.height.greaterThanOrEqualTo(25)
                
                imageCountLabel.snp.makeConstraints {
                    $0.edges.equalToSuperview().inset(imageCountBackgroundView.layoutMargins)
                }
            }
            
            imageCountBackgroundView.layoutIfNeeded()
            imageCountBackgroundView.layer.cornerRadius = imageCountBackgroundView.frame.height / 2
        }
    }
}
