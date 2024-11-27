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
    
    //MARK: - UI
    
    private func setUI() {
        avatarImageView.do {
            $0.layer.cornerRadius = 50/2
            $0.isUserInteractionEnabled = true
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
    
    func bindData(avatarImage: String, isRepresentative: Bool) {
        avatarImageView.do {
            $0.kfSetImage(url: makeBucketImageURLString(path: avatarImage))
            
            if (isRepresentative) {
                $0.layer.borderColor = UIColor.wssPrimary100.cgColor
                $0.layer.borderWidth = 5
            }
        }
    }
}
