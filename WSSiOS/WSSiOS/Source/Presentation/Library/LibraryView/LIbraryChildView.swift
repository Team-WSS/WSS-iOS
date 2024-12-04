//
//  View.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

import SnapKit
import Then

final class LibraryChildView: UIView {
    
    //MARK: - Components
    let descriptionView = LibraryDescriptionView()
    let libraryListView = LibraryListView()
    lazy var libraryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let libraryEmptyView = LibraryEmptyView()
    
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
        libraryCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 20.0
            layout.minimumInteritemSpacing = 6
            layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: 108.0, height: 240.0)
            
            $0.collectionViewLayout = layout
            $0.showsVerticalScrollIndicator = false
        }
        
        libraryEmptyView.isHidden = true
        libraryListView.isHidden = true
    }
  
    private func setHierarchy() {
        self.addSubviews(descriptionView,
                         libraryCollectionView,
                         libraryEmptyView,
                         libraryListView)
    }
    
    private func setLayout() {
        descriptionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        libraryCollectionView.snp.makeConstraints() {
            $0.top.equalTo(descriptionView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        libraryEmptyView.snp.makeConstraints() {
            $0.top.equalTo(descriptionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        libraryListView.snp.makeConstraints() {
            $0.top.equalTo(descriptionView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(25)
            $0.width.equalTo(100)
            $0.height.equalTo(104)
        }
    }
    
    func resetUI(title: String) {
        descriptionView.libraryNovelListButton.do {
            let title = title
            var attString = AttributedString(title)
            attString.font = UIFont.Label1
            attString.foregroundColor = UIColor.Gray300
            
            var configuration = UIButton.Configuration.filled()
            configuration.attributedTitle = attString
            configuration.image = UIImage.icDropDown
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
            configuration.imagePlacement = .trailing
            configuration.baseBackgroundColor = UIColor.clear
            $0.configuration = configuration
        }
    }
}

