//
//  NovelDetailBannerImageView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/27/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then
import UIImageViewAlignedSwift

final class NovelDetailHeaderBackgroundImageView: UIView {
    
    //MARK: - Properties
    
    private let blurRadius: CGFloat = 4
    
    //MARK: - Components
    
    private let bannerImageView = UIImageViewAligned()
    private let gradation = UIImageView()
    
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
        bannerImageView.do {
            $0.image = .imgLoadingThumbnail.asBlurredBannerImage(radius: blurRadius)
            $0.contentMode = .scaleAspectFill
            $0.alignment = .top
            $0.clipsToBounds = true
            
            gradation.do {
                $0.image = .imgBackgroundGradation
                $0.contentMode = .scaleToFill
                $0.clipsToBounds = true
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(bannerImageView)
        bannerImageView.addSubview(gradation)
    }
    
    private func setLayout() {
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
            gradation.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ novelImage: UIImage) {
        self.bannerImageView.image = novelImage.asBlurredBannerImage(radius: self.blurRadius)
    }
}
