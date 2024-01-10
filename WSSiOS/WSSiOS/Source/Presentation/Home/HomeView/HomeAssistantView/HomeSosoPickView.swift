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
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
        setCollectionViewLayout()
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
    }
    
    private func setHierachy() {
        self.addSubview(sosoPickCollectionView)
    }
    
    private func setLayout() {
        sosoPickCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 11
        flowLayout.itemSize = CGSize(width: 230, height: 195)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        sosoPickCollectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
}
