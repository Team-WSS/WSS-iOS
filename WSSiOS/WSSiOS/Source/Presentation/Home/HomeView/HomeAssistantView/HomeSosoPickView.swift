//
//  HomeSosoPickView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/11/24.
//

import UIKit

final class HomeSosoPickView: UIView {
    
    //MARK: - UI Components
    
    let sosoPickCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let sosoPickCollectionViewLayout = UICollectionViewFlowLayout()
    
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
        sosoPickCollectionView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
        }
        
        sosoPickCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 11
            $0.itemSize = CGSize(width: 230, height: 195)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            sosoPickCollectionView.setCollectionViewLayout($0, animated: false)
        }
    }
    
    private func setHierachy() {
        self.addSubview(sosoPickCollectionView)
    }
    
    private func setLayout() {
        sosoPickCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
