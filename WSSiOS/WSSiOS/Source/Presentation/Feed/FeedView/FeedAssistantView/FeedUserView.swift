//
//  FeedUserView.swift
//  WSSiOS
//
//  Created by 신지원 on 5/15/24.
//

import UIKit

import SnapKit
import Then

final class FeedUserView: UIView {
    
    //MARK: - Components
    
    private let userImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    
    // MARK: - Life Cycle
    
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
        self.backgroundColor = .wssWhite
        
        userImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
        }
        
        userNicknameLabel.do {
            $0.font = .Title2
            $0.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        addSubviews(userImageView,
                    userNicknameLabel)
    }
    
    private func setLayout() {
        userImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(36)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(userImageView.snp.trailing).offset(14)
        }
    }
    
    //MARK: - Data
    
    func bindData(imageURL: String, nickname: String) {
        userImageView.kfSetImage(url: imageURL)
        userNicknameLabel.text = nickname
    }
}
