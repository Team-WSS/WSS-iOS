//
//  HomeSosoPickCollectionViewCell.swift
//  WSSiOS
//
//  Created by 최서연 on 1/11/24.
//

import UIKit

final class HomeSosoPickCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "HomeSosoPickCollectionViewCell"
    
    //MARK: - UI Components
    
    private let bottomBackgroundView = UIView()
    private let novelImageView = UIImageView()
    
    private let novelStackView = UIStackView()
    private let novelUserNumberView = HomeSosoPickUserNumberChipView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .Primary80
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        bottomBackgroundView.do {
            $0.backgroundColor = .White
        }
        
        novelImageView.do {
            $0.image = UIImage(named: "sample1")
        }
        
        novelStackView.do {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.spacing = 1
        }
        
        novelTitleLabel.do {
            $0.text = "당신의 잠을 위해 노력한다네"
            $0.font = .Title2
            $0.textColor = .Black
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        novelAuthorLabel.do {
            $0.text = "최서연영애"
            $0.font = .Body3
            $0.textColor = .Gray200
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
    
    private func setHierachy() {
        self.addSubviews(novelImageView,
                         bottomBackgroundView)
        bottomBackgroundView.addSubviews(novelUserNumberView,
                                         novelStackView)
        novelStackView.addArrangedSubviews(novelTitleLabel,
                                           novelAuthorLabel)
    }
    
    private func setLayout() {
        novelImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.leading.equalToSuperview().inset(83)
            $0.width.equalTo(64)
            $0.height.equalTo(93)
        }
        
        bottomBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(101)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        novelUserNumberView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
        }
        
        novelStackView.snp.makeConstraints {
            $0.top.equalTo(novelUserNumberView.snp.bottom).offset(7)
            $0.leading.equalTo(novelUserNumberView.snp.leading)
        }
    }
}


