//
//  BannerImageView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/6/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then
import UIImageViewAlignedSwift

final class RegisterNormalBannerImageView: UIView {
    
    //MARK: - Components
    
    private let bannerImageView = UIImageViewAligned()
    private let gradientView = UIImageView()
    
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
            $0.image = .imgLoadingBanner.asBlurredBannerImage(radius: 15)
            $0.contentMode = .scaleAspectFill
            $0.alignment = .top
            $0.clipsToBounds = true
            
            gradientView.do {
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                $0.image = .imgBackgroundGradation
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubview(bannerImageView)
        bannerImageView.addSubview(gradientView)
    }
    
    private func setLayout() {
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(251)
            
            gradientView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ novelImage: String) {
        if let novelImageUrl = URL(string: novelImage) {
            KingfisherManager.shared.retrieveImage(with: novelImageUrl, completionHandler: { result in
            switch(result) {
            case .success(let imageResult):
                let blurredImage = imageResult.image.asBlurredBannerImage(radius: 5)
//                self.bannerImageView.image = blurredImage
            case .failure(let error):
                print(error)
                }
            })
        }
    }
}
