//
//  NovelDetailNovelCoverView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderCoverImageButton: UIButton {
    
    //MARK: - Components
    
    private let novelCoverShadowView = UIView()
    private let novelCoverImageView = UIImageView()
    private let novelGenreImageView = UIImageView()
    
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
        novelCoverShadowView.do {
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 15
            $0.layer.masksToBounds = false
            $0.isUserInteractionEnabled = false
            
            novelCoverImageView.do {
                $0.image = .imgLoadingThumbnail
                $0.contentMode = .scaleAspectFill
                $0.layer.cornerRadius = 8
                $0.clipsToBounds = true
                
                    novelGenreImageView.do {
                        $0.image = .icGenreBackground
                        $0.contentMode = .scaleAspectFit
                    }
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(novelCoverShadowView)
        novelCoverShadowView.addSubviews(novelCoverImageView,
                                         novelGenreImageView)
    }
    
    private func setLayout() {
        novelCoverShadowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(217)
            $0.width.equalTo(148)
            
            novelCoverImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            novelGenreImageView.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.size.equalTo(71)
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailHeaderResult) {
        novelCoverImageView.image = UIImage(named: data.novelImage)
        novelGenreImageView.image = UIImage(named: data.novelGenreImage)
    }
}
