//
//  LibraryCollectionViewCell.swift
//  WSSiOS
//
//  Created by 신지원 on 1/14/24.
//

import UIKit

class LibraryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier: String = "LibraryCollectionViewCell"
    
    //MARK: - UI Components
    
    private var stackView = UIStackView()
    public var novelImageView = UIImageView()
    public var novelTitleLabel = UILabel()
    public var novelAuthorLabel = UILabel()
    public var ratingStackView = UIStackView() 
    private let ratingStarImage = UIImageView(image: ImageLiterals.icon.Star.fill)
    public var novelRatingLabel = UILabel()
    
    //MARK: - Life Cycle
    
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
    
    //MARK: - Set UI
    
    private func setUI() {
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .fill
        }
        
        novelImageView.do {
            $0.layer.cornerRadius = 10
        }
        
        novelTitleLabel.do {
            $0.font = .Body2
            $0.textColor = .Black
            $0.textAlignment = .left
            $0.numberOfLines = 2
        }
        
        novelAuthorLabel.do {
            $0.font = .Label1
            $0.textColor = .Gray200
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        ratingStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 5
        }
        
        novelRatingLabel.do {
            $0.font = .Label1
            $0.textColor = .Black
        }
    }
    
    //MARK: - Set Hierachy
    
    private func setHierachy() {
        self.addSubviews(stackView)
        stackView.addArrangedSubviews(novelImageView,
                                      novelTitleLabel,
                                      novelAuthorLabel,
                                      ratingStackView)
        ratingStackView.addArrangedSubviews(ratingStarImage,
                                            novelRatingLabel)
    }
    
    //MARK: - Set Layout
    
    private func setLayout() {
        stackView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
        
        novelImageView.snp.makeConstraints() {
            $0.width.equalToSuperview()
            $0.height.equalTo(105)
        }
        
        ratingStarImage.snp.makeConstraints() {
            $0.size.equalTo(10)
        }
    }
}
