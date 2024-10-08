////
////  TrashMyPageInventoryView.swift
////  WSSiOS
////
////  Created by 신지원 on 1/10/24.
////
//
//import UIKit
//
//import SnapKit
//import Then
//
//final class TrashMyPageInventoryView: UIView {
//    
//    //MARK: - Components
//    
//    private let titleLabel = UILabel()
//    lazy var myPageAvaterCollectionView = UICollectionView(frame: .zero,
//                                                collectionViewLayout: UICollectionViewFlowLayout())
//    
//    // MARK: - Life Cycle
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        setUI()
//        setHierarchy()
//        setLayout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: - UI
//    
//    private func setUI() {
//        self.backgroundColor = .wssWhite
//        
//        titleLabel.do {
//            $0.text = StringLiterals.MyPage.Character.select
//            $0.font = .Title1
//            $0.textColor = .wssBlack
//        }
//        
//        myPageAvaterCollectionView.do {
//            let layout = UICollectionViewFlowLayout()
//            layout.scrollDirection = .horizontal
//            layout.minimumLineSpacing = 0.0
//            layout.itemSize = CGSize(width: 84.0,
//                                     height: 96.0)
//            
//            $0.collectionViewLayout = layout
//        }
//    }
//
//    private func setHierarchy() {
//        self.addSubviews(titleLabel,
//                         myPageAvaterCollectionView)
//    }
//
//    private func setLayout() {
//        titleLabel.snp.makeConstraints() {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview().inset(20)
//        }
//        
//        myPageAvaterCollectionView.snp.makeConstraints() {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(97)
//            $0.bottom.equalToSuperview().inset(35)
//        }
//    }
//}
