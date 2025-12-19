//
//  MyPageEditAvatarCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 11/25/24.
//

import UIKit

import SnapKit
import Then

final class MyPageEditAvatarCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    
    private let avatarImageView = UIImageView()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
        avatarImageView.clipsToBounds = true
    }
    
    //MARK: - UI
    
    private func setUI() {
        avatarImageView.do {
            $0.contentMode = .scaleAspectFill
        }
    }
    
    private func setHierarchy() {
        self.addSubview(avatarImageView)
    }
    
    private func setLayout() {
        avatarImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(avatarImageURL: URL?, isRepresentative: Bool) {
        avatarImageView.do {
            if avatarImageURL == nil {
                $0.image = .imgProfile
            } else {
                $0.image = .imgProfile
                $0.kfSetImage(url: avatarImageURL)
            }
        }
        
        if isRepresentative {
            avatarImageView.layer.borderWidth = 2
            avatarImageView.layer.borderColor = UIColor.wssPrimary100.cgColor
        }
    }
}
