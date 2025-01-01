//
//  FeedEditConnectedNovelView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 6/29/24.
//

import UIKit

import SnapKit
import Then

final class FeedEditConnectedNovelView: UIView {
    
    //MARK: - Components
    
    private let contentView = UIView()
    private let novelConnectImageView = UIImageView()
    private let novelTitleLabel = UILabel()
    let removeButton = UIButton()
    
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
        self.do {
            $0.isHidden = true
        }
        
        contentView.do {
            $0.backgroundColor = .wssPrimary20
            $0.layer.cornerRadius = 14
        }
        
        novelConnectImageView.do {
            $0.image = .icNovelLink
            $0.contentMode = .scaleAspectFit
        }
        
        novelTitleLabel.do {
            $0.textColor = .wssBlack
        }
        
        removeButton.do {
            $0.setImage(.icCancel, for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(contentView)
        contentView.addSubviews(novelConnectImageView,
                                novelTitleLabel,
                                removeButton)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        novelConnectImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(18)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(novelConnectImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(removeButton.snp.leading).offset(-16)
        }
        
        removeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(18)
        }
    }
    
    //MARK: - Data
    
    func bindData(novelTitle: String?) {
        if let novelTitle {
            self.isHidden = false
            
            self.novelTitleLabel.do {
                $0.applyWSSFont(.title3, with: novelTitle)
            }
        } else {
            self.isHidden = true
        }
    }
}
