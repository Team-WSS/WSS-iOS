//
//  MyPageBlockUserTableViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 7/29/24.
//

import UIKit

import Kingfisher
import RxSwift
import SnapKit
import Then

final class MyPageBlockUserTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    //MARK: - Components
    
    private var userImageView = UIImageView()
    private var userNicknameLabel = UILabel()
    private var unblockLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            if unblockLabel.frame.contains(point) {
                return true
            }
        return false
        }
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.selectionStyle = .none
        }
        
        userImageView.do {
            $0.image = .imgProfile
            $0.layer.cornerRadius = 14
            $0.contentMode = .scaleToFill
            $0.clipsToBounds = true
        }
        
        userNicknameLabel.do {
            $0.textColor = .wssBlack
        }
        
        unblockLabel.do {
            $0.applyWSSFont(.body3, with: StringLiterals.MyPage.BlockUser.buttonTitle)
            $0.textColor = .wssGray300
            $0.textAlignment = .center
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
            $0.isUserInteractionEnabled = true
        }
    }
    
    private func setHierarchy() {
        contentView.addSubviews(userImageView,
                                userNicknameLabel,
                                unblockLabel)
    }
    
    
    private func setLayout() {
        userImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(50)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(userImageView.snp.trailing).offset(14)
        }
        
        unblockLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(77)
            $0.height.equalTo(35)
        }
    }
    
    //MARK: - Data
    
    func bindData(image: String, nickname: String) {
        userImageView.kfSetImage(url: makeBucketImageURLString(path: image))
        userNicknameLabel.applyWSSFont(.body2, with: nickname)
    }
}

