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
    
    var myPageAvaterImageView = UIImageView()
    
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
        myPageAvaterImageView.do {
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
        }
    }
    
    //MARK: - Set Hierachy
    
    private func setHierachy() {
        self.addSubview(myPageAvaterImageView)
    }
    
    //MARK: - Set Layout
    
    private func setLayout() {
        myPageAvaterImageView.snp.makeConstraints() {
            $0.height.width.equalToSuperview()
        }
    }
    
    // 네트워크 연결 후 수정 예정
    
    func bindData(_ selected: Bool) {
        myPageAvaterImageView.image = UIImage(named: "exampleAvater")

        if selected {
            myPageAvaterImageView.layer.borderColor = UIColor.Primary100.cgColor
            myPageAvaterImageView.layer.borderWidth = 1
        }else {
            myPageAvaterImageView.layer.borderColor = UIColor.Primary100.cgColor
            myPageAvaterImageView.layer.borderWidth = 1
        }
    }
}
