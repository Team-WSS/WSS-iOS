//
//  NovelKeywordSelectCategoryView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/28/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class NovelKeywordSelectCategoryView: UIView {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private let keywordCategory: KeywordCategory
    private var isExpanded: Bool = false
    var collectionViewHeight: CGFloat = 0
    
    //MARK: - Components
    
    private let contentView = UIView()
    private let categoryImageView = UIImageView()
    private let categoryLabel = UILabel()
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let dividerView = UIView()
    let expandButton = UIButton()
    private let arrowImageView = UIImageView()
    
    //MARK: - Life Cycle
    
    init(keywordCategory: KeywordCategory) {
        self.keywordCategory = keywordCategory
        super.init(frame: .zero)
        
        register()
        delegate()
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func register() {
        categoryCollectionView.register(NovelKeywordSelectSearchResultCollectionViewCell.self, forCellWithReuseIdentifier: NovelKeywordSelectSearchResultCollectionViewCell.cellIdentifier)
    }
    
    private func delegate() {
        categoryCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        contentView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 11
            $0.clipsToBounds = true
        }
        
        categoryImageView.do {
            $0.kfSetImage(url: makeBucketImageURLString(path: keywordCategory.categoryImage))
            $0.layer.cornerRadius = 10.67
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        
        categoryLabel.do {
            $0.applyWSSFont(.title2, with: keywordCategory.categoryName)
            $0.textColor = .wssGray300
        }
        
        categoryCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 6

            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
            $0.allowsMultipleSelection = true
        }
        
        dividerView.do {
            $0.backgroundColor = .wssGray50
        }
        
        arrowImageView.do {
//            $0.image = .icChevronDown
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(contentView)
        contentView.addSubviews(categoryImageView,
                                categoryLabel,
                                categoryCollectionView,
                                dividerView,
                                expandButton)
        expandButton.addSubview(arrowImageView)
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
            $0.size.equalTo(32)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryImageView.snp.centerY)
            $0.leading.equalTo(categoryImageView.snp.trailing).offset(8)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(78)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        expandButton.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(44)
            
            arrowImageView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(44)
            }
        }
    }
    
    //MARK: - Custom Methos
    
    func expandCategoryCollectionView() {
        categoryCollectionView.snp.updateConstraints {
            $0.height.equalTo(isExpanded ? 78 : self.collectionViewHeight)
        }
        
        self.isExpanded = !self.isExpanded
    }
}

extension NovelKeywordSelectCategoryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var text: String?
        
        text = self.keywordCategory.keywords[indexPath.item].keywordName
        
        guard let unwrappedText = text else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = (unwrappedText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.Body2]).width + 26
        return CGSize(width: width, height: 35)
    }
}
