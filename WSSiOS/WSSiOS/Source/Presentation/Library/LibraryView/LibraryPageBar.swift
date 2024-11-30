//
//  LibraryPageBar.swift
//  WSSiOS
//
//  Created by 신지원 on 1/15/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class LibraryPageBar: UIView {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Components
    
    public lazy var libraryTabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
        libraryTabCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4, height: 54.0)
            
            $0.collectionViewLayout = layout
        }
    }

    private func setHierarchy() {
        self.addSubview(libraryTabCollectionView)
    }
    
    private func setLayout() {
        libraryTabCollectionView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
    }
}
