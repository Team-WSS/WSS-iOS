//
//  NovelDetailReviewInfoElementView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/28/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailReviewInfoElementView: UIView {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    
    private let reviewSymbolImageView = UIImageView()
    private let reviewInfoLabel = UILabel()
    
    //MARK: - Life Cycle
    
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
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .center
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubviews(reviewSymbolImageView,
                                      reviewInfoLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func setText(with text: String) {
        reviewInfoLabel.do {
            $0.fontBody5_2Attribute(with: text)
            $0.textColor = .wssGray300
            $0.textAlignment = .center
            $0.numberOfLines = 1
        }
    }
    
    func setImage(_ image: UIImage) {
        reviewSymbolImageView.do {
            $0.image = image
        }
    }
}
