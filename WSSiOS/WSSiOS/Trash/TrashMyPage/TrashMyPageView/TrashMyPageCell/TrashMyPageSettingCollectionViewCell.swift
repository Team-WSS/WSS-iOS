////
////  TrashMyPageSettingCollectionViewCell.swift
////  WSSiOS
////
////  Created by 신지원 on 1/11/24.
////
//
//import UIKit
//
//import SnapKit
//import Then
//
//final class TrashMyPageSettingCollectionViewCell: UICollectionViewCell {
//     
//    //MARK: - Components
//    
//    let myPageSettingCellLabel = UILabel()
//    
//    //MARK: - Life Cycle
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        setUI()
//        setHierarchy()
//        setLayout()
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: - UI
//    
//    private func setUI() {
//        self.backgroundColor = .wssWhite
//        
//        myPageSettingCellLabel.do {
//            $0.textColor = .wssBlack
//            $0.font = .Body1
//        }
//    }
//    
//    private func setHierarchy() {
//        self.addSubviews(myPageSettingCellLabel)
//    }
//
//    private func setLayout() {
//        myPageSettingCellLabel.snp.makeConstraints() {
//            $0.centerY.equalToSuperview()
//            $0.leading.equalToSuperview().inset(20)
//        }
//    }
//}
