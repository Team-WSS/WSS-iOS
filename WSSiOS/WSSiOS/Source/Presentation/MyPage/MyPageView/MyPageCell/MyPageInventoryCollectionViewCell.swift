//
//  TableViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class MyPageInventoryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    
    let myPageAvaterImageView = UIImageView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        myPageAvaterImageView.do {
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFit
        }
    }
    
    
    private func setHierarchy() {
        self.addSubview(myPageAvaterImageView)
    }
    
    
    private func setLayout() {
        myPageAvaterImageView.snp.makeConstraints() {
            $0.height.width.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(data: UserAvatar, representativeId: Int) {
        myPageAvaterImageView.kfSetImage(url: data.avatarImg)
        
        let isRepresentative = representativeId == data.avatarId
        myPageAvaterImageView.layer.borderColor = isRepresentative ? UIColor.Primary100.cgColor : UIColor.clear.cgColor
    }
}
