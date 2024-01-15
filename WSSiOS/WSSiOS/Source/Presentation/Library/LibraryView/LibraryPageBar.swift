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

class LibraryPageBar: UIView {

    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    public var selectedTabIndex = PublishSubject<Int>()
    
    //MARK: - UI Components
    
    public var libraryTabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - set UI
    
    private func setUI() {
        libraryTabCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.itemSize = CGSize(width: 67.0, height: 54.0)
            
            $0.collectionViewLayout = layout
        }
        
        libraryTabCollectionView.rx.itemSelected
            .map{$0.row}
            .bind(to: selectedTabIndex)
            .disposed(by: disposeBag)
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(libraryTabCollectionView)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        libraryTabCollectionView.snp.makeConstraints() {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
