//
//  NovelInfoWithRatingView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/7/24.
//

import UIKit

import SnapKit
import Then

final class RegisterNormalNovelInfoWithRatingView: UIView {
    
    // MARK: - UI Components
    
    private let novelInfoWithRatingContentView = UIStackView()
    private let novelInfoStackView = RegisterNormalNovelInfoView()
    private let novelCoverImageView = UIImageView()
    private let novelImageShadowView = UIView()
    let starRatingView = RegisterNormalStarRatingView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        novelInfoWithRatingContentView.do {
            $0.axis = .vertical
            $0.spacing = 22
            $0.alignment = .center
            
            novelCoverImageView.do {
                $0.image = .registerNormalNovelCover
                $0.contentMode = .scaleAspectFill
                $0.layer.cornerRadius = 12
                $0.clipsToBounds = true
            }
            
            novelImageShadowView.do {
                $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
                $0.layer.shadowOpacity = 1
                $0.layer.shadowOffset = CGSize(width: 0, height: 2)
                $0.layer.shadowRadius = 15
            }
        }
    }
    
    private func setHieararchy() {
        self.addSubview(novelInfoWithRatingContentView)
        novelImageShadowView.addSubview(novelCoverImageView)
        novelInfoWithRatingContentView.addArrangedSubviews(novelInfoStackView,
                                                           novelImageShadowView,
                                                           starRatingView)
    }
    
    private func setLayout() {
        novelInfoWithRatingContentView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(67)
            
            novelImageShadowView.snp.makeConstraints {
                $0.height.equalTo(novelImageShadowView.snp.width).multipliedBy(197.0/128.0)
                $0.horizontalEdges.equalToSuperview().inset(56.5)
            }
            novelCoverImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
