//
//  HomeSearchButtonView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class HomeSearchButtonView: UIView {
    
    //MARK: - UI Components
    
    private let searchImageView = UIImageView()
    private let searchDescriptionLabel = UILabel()
    private let searchUnderLine = UIView()
    
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
    
    //MARK: - set UI
    
    private func setUI() {
        searchImageView.do {
            $0.image = ImageLiterals.icon.search
        }
        
        searchDescriptionLabel.do {
            $0.text = "등록할 작품 검색하기"
            $0.font = .Body2
            $0.textColor = .Gray200
        }
        
        searchUnderLine.do {
            $0.backgroundColor = .Gray100
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(searchImageView,
                         searchDescriptionLabel,
                         searchUnderLine)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        searchImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        searchDescriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(searchImageView.snp.trailing).offset(8)
            $0.bottom.equalTo(searchImageView.snp.bottom).inset(1)
        }
        
        searchUnderLine.snp.makeConstraints {
            $0.leading.equalTo(searchImageView.snp.leading)
            $0.top.equalTo(searchImageView.snp.bottom).offset(10)
            $0.height.equalTo(2)
            $0.width.equalTo(224)
        }
    }
}
