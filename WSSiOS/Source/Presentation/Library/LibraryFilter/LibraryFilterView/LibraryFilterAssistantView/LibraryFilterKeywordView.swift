//
//  LibraryFilterKeywordView.swift
//  WSSiOS
//
//  Created by YunhakLee on 6/21/26.
//

import UIKit

import SnapKit
import Then

final class LibraryFilterKeywordView: UIView {

    //MARK: - Properties

    private var keywords: [KeywordData] = []
    private var selectedKeywords: [KeywordData] = []

    //MARK: - UI Components

    private let countLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
    private var collectionViewHeightConstraint: Constraint?
    private var lastContentHeight: CGFloat = 0
    
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
        countLabel.do {
            $0.applyWSSFont(.body4,
                            with: StringLiterals.MyLibrary.Filter.registeredKeywordCount(keywords.count))
            $0.textColor = .wssGray200
        }
        
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
        self.addSubviews(countLabel,
                         collectionView)
    }
    
    private func setLayout() {
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            collectionViewHeightConstraint = $0.height.equalTo(0).constraint
            $0.bottom.equalToSuperview()
        }
    }

    //MARK: - Life Cycle

    /// 컬렉션 콘텐츠 높이만큼 self-sizing (외부 scrollView가 스크롤을 담당)
    override func layoutSubviews() {
        super.layoutSubviews()

        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height

        // 채워져 있는데 레이아웃 전 transient 0이면 무시, 비어 있으면 0으로 축소 허용
        if !keywords.isEmpty && contentHeight == 0 { return }
        guard contentHeight != lastContentHeight else { return }

        lastContentHeight = contentHeight
        collectionViewHeightConstraint?.update(offset: contentHeight)
    }

    //MARK: - Custom Method
    
    func setKeywords(_ keywords: [KeywordData]) {
        self.keywords = keywords
        countLabel.applyWSSFont(.body4,
                                with: StringLiterals.MyLibrary.Filter.registeredKeywordCount(keywords.count))
        collectionView.reloadData()
    }
    
    func updateSelection(_ selectedKeywords: [KeywordData]) {
        self.selectedKeywords = selectedKeywords
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource

extension LibraryFilterKeywordView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LibraryFilterChipCell.identifier,
            for: indexPath
        ) as? LibraryFilterChipCell else {
            return UICollectionViewCell()
        }
        
        let keyword = keywords[indexPath.item]
        cell.configure(title: keyword.keywordName,
                       isSelected: selectedKeywords.contains(keyword))
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension LibraryFilterKeywordView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension LibraryFilterKeywordView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = keywords[indexPath.item].keywordName
        let textWidth = (text as NSString).size(withAttributes: [.font: WSSFont.body2.font]).width
        return CGSize(width: textWidth + 26, height: 37)
    }
}
