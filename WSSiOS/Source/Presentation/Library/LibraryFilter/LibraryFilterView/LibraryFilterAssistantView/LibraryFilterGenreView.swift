//
//  LibraryFilterGenreView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterGenreView: UIView {

    //MARK: - Properties

    private let genres = NovelGenre.detailSearchGenres
    private var selectedGenres: [NovelGenre] = []

    //MARK: - UI Components

    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
    
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
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 14
            layout.minimumInteritemSpacing = 6
            
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.allowsMultipleSelection = false
            $0.dataSource = self
            $0.delegate = self
            $0.register(LibraryFilterChipCell.self,
                        forCellWithReuseIdentifier: LibraryFilterChipCell.identifier)
        }
    }
    
    private func setHierarchy() {
        self.addSubview(collectionView)
    }
    
    private func setLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(88)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateSelection(_ selectedGenres: [NovelGenre]) {
        self.selectedGenres = selectedGenres
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource

extension LibraryFilterGenreView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LibraryFilterChipCell.identifier,
            for: indexPath
        ) as? LibraryFilterChipCell else {
            return UICollectionViewCell()
        }
        
        let genre = genres[indexPath.item]
        cell.configure(title: genre.withKorean,
                       isSelected: selectedGenres.contains(genre))
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension LibraryFilterGenreView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension LibraryFilterGenreView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = genres[indexPath.item].withKorean
        let textWidth = (text as NSString).size(withAttributes: [.font: WSSFont.body2.font]).width
        return CGSize(width: textWidth + 26, height: 37)
    }
}
