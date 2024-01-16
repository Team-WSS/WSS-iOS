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

    //MARK: - Properties
    
    static let identifier: String = "MyPageInventoryTableViewCell"
    
    //MARK: - UI Components
    
    var myPageAvaterButton = UIButton()
    
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
    
    //MARK: - Set UI
    
    private func setUI() {
        myPageAvaterButton.do {
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
        }
    }
    
    //MARK: - Set Hierachy
    
    private func setHierachy() {
        self.addSubview(myPageAvaterButton)
    }
    
    //MARK: - Set Layout
    
    private func setLayout() {
        myPageAvaterButton.snp.makeConstraints() {
            $0.height.width.equalToSuperview()
        }
    }
    
    // 네트워크 연결 후 수정 예정
    
    func bindData(_ data: UserAvatar) {
        myPageAvaterButton.kfSetButtonImage(url: data.avatarImg, state: .normal)

//        if {
//            myPageAvaterButton.layer.borderColor = UIColor.Primary100.cgColor
//            myPageAvaterButton.layer.borderWidth = 1
//        }else {
//            myPageAvaterButton.layer.borderColor = UIColor.Primary100.cgColor
//            myPageAvaterButton.layer.borderWidth = 1
//        }
    }
}
