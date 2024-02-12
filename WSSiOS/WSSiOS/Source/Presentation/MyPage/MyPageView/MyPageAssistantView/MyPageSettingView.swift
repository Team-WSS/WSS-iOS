//
//  MyPageSettingView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class MyPageSettingView: UIView {

    //MARK: - Components
    
    lazy var myPageSettingCollectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: UICollectionViewFlowLayout())
    
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
        self.backgroundColor = .Gray50
        
        myPageSettingCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 1.0
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width,
                                     height: 64.0)
            
            $0.collectionViewLayout = layout
            $0.backgroundColor = .Gray50
        }
    }

    private func setHierarchy() {
        self.addSubview(myPageSettingCollectionView)
    }

    private func setLayout() {
        myPageSettingCollectionView.snp.makeConstraints() {
            $0.top.equalToSuperview().inset(7)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
