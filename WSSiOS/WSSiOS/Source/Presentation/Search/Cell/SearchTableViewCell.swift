//
//  SearchTableViewCell.swift
//  WSSiOS
//
//  Created by 최서연 on 1/7/24.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {
    
    //MARK: set Properties
    
    static let identifier: String = "SearchCollectionViewCell"
    
    private let novelImageView = UIImageView()
    private let novelTitleLabel = UILabel()
    private let novelAuthorLabel = UILabel()
    private let novelGenreLabel = UILabel()
    
    //MARK: Life Cycle
    
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
    
    //MARK: set UI
    
    private func setUI() {
        novelTitleLabel.do {
            $0.font = .Title2
            $0.textColor = .Black
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
            $0.lineBreakStrategy = .hangulWordPriority
        }
        
        novelAuthorLabel.do {
            $0.font = .Label1
            $0.textColor = .Gray200
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        novelGenreLabel.do {
            $0.font = .Label1
            $0.textColor = .Gray200
        }
    }
    
    //MARK: set Hierachy
    
    private func setHierachy() {
        self.addSubviews(novelImageView,
                         novelTitleLabel,
                         novelAuthorLabel,
                         novelGenreLabel)
    }
    
    //MARK: set Layout
    
    private func setLayout() {
        novelImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(76)
            $0.height.equalTo(104)
        }
        
        novelTitleLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalTo(novelImageView.snp.trailing).offset(10)
        }
        
        novelAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(novelTitleLabel.snp.bottom)
            $0.leading.equalTo(novelTitleLabel.snp.leading)
            $0.trailing.equalToSuperview()
        }
        
        novelGenreLabel.snp.makeConstraints {
            $0.top.equalTo(novelAuthorLabel.snp.bottom)
            $0.leading.equalTo(novelAuthorLabel.snp.leading)
            $0.trailing.equalToSuperview()
        }
    }
    
    func bindData(data: SearchNovel) {
        novelImageView.image = data.novelImage
        novelTitleLabel.text = data.novelTitle
        novelAuthorLabel.text = data.novelAuthor
        novelGenreLabel.text = data.novelGenre
    }
}
