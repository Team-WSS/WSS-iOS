//
//  LibraryFilterSelectedChipsView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterSelectedChipsView: UIView {

    //MARK: - Properties

    private var chips: [LibraryFilterChip] = []

    //MARK: - UI Components

    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
    private let dividerView = UIView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        collectionView.do {
            guard let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 6
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.dataSource = self
            $0.delegate = self
            $0.register(LibraryFilterSelectedChipCell.self,
                        forCellWithReuseIdentifier: LibraryFilterSelectedChipCell.identifier)
        }

        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
    }

    private func setHierarchy() {
        self.addSubviews(collectionView,
                         dividerView)
    }

    private func setLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(35)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func update(_ chips: [LibraryFilterChip]) {
        self.chips = chips
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource

extension LibraryFilterSelectedChipsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chips.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LibraryFilterSelectedChipCell.identifier,
            for: indexPath
        ) as? LibraryFilterSelectedChipCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(title: chips[indexPath.item].title)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension LibraryFilterSelectedChipsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension LibraryFilterSelectedChipsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = chips[indexPath.item].title
        let textWidth = (text as NSString).size(withAttributes: [.font: WSSFont.body2.font]).width
        return CGSize(width: textWidth + 38, height: 35)
    }
}
