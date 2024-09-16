//
//  DetailSearchKeywordCategoryCollectionViewCell.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 9/10/24.
//

import UIKit

import RxSwift

final class DetailSearchKeywordCategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Components
    
    let keywordImageView = UIImageView()
    let keywordTitleLabel = UILabel()
    let keywordCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: UICollectionViewLayout())
    private let dividerView = UIView()
    private let downArrowImageView = UIImageView()
    private let upArrowImageView = UIImageView()
    
    //MARK: - Properties
    
    private var keywords: [DetailSearchKeyword] = []
    var isExpanded: Bool = false
    private let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        setActions()
        observeContentSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 11
            $0.clipsToBounds = true
        }
        
        keywordImageView.do {
            $0.layer.cornerRadius = 10.67
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        
        keywordTitleLabel.do {
            $0.textColor = .wssGray300
        }
        
        keywordCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 6
            
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
            
            $0.register(DetailSearchInfoGenreCollectionViewCell.self,
                        forCellWithReuseIdentifier: DetailSearchInfoGenreCollectionViewCell.cellIdentifier)
            
            $0.delegate = self
            $0.dataSource = self
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
        
        downArrowImageView.do {
            $0.image = .icChevronDown
            $0.isUserInteractionEnabled = true
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(keywordImageView,
                         keywordTitleLabel,
                         keywordCollectionView,
                         dividerView,
                         downArrowImageView)
    }
    
    private func setLayout() {
        keywordImageView.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        keywordTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(keywordImageView.snp.centerY)
            $0.top.equalToSuperview().inset(25)
            $0.leading.equalTo(keywordImageView.snp.trailing).offset(8)
        }
        
        keywordCollectionView.snp.makeConstraints {
            $0.top.equalTo(keywordImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(78)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(keywordCollectionView.snp.bottom).offset(34)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        downArrowImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.top.equalTo(dividerView.snp.bottom).offset(13)
            $0.bottom.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCollectionView))
        downArrowImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func toggleCollectionView() {
        isExpanded.toggle()
        downArrowImageView.image = isExpanded ? .icChevronUp : .icChevronDown
        
        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
    }

    func updateCollectionViewHeight(height: CGFloat) {
        keywordCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    func bindData(data: DetailSearchCategory) {
        keywordImageView.kfSetImage(url: makeBucketImageURLString(path: data.categoryImage))
        keywordTitleLabel.applyWSSFont(.title2, with: data.categoryName)
        keywordTitleLabel.text = data.categoryName
        self.keywords = data.keywords
        keywordCollectionView.reloadData()
    }
    
   private func observeContentSize() {
       keywordCollectionView.rx.observe(CGSize.self, "contentSize")
           .compactMap { $0 }
           .subscribe(with: self, onNext: { owner, size in
               self.updateCollectionViewHeight(height: size.height)
           })
           .disposed(by: disposeBag)
    }
}

extension DetailSearchKeywordCategoryCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailSearchInfoGenreCollectionViewCell.cellIdentifier, for: indexPath) as? DetailSearchInfoGenreCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let keyword = keywords[indexPath.row]
        cell.bindData(genre: keyword.keywordName)
        
        return cell
    }
}

extension DetailSearchKeywordCategoryCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func keywordNameForItemAt(indexPath: IndexPath) -> String? {
        guard indexPath.item < keywords.count else {
            return nil
        }
        
        return keywords[indexPath.item].keywordName
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let text = keywordNameForItemAt(indexPath: indexPath) else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
        return CGSize(width: width, height: 37)
    }
}
