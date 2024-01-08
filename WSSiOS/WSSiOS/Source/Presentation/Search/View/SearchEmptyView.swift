//
//  SearchEmptyView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/6/24.
//

import UIKit

import SnapKit
import Then

final class SearchEmptyView: UIView {
    
    //MARK: - set Porperties
    
    private let emptyImageView = UIImageView()
    private let emptyDescriptionLabel = UILabel()
    
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
        emptyImageView.do {
            $0.image = ImageLiterals.icon.icBookRegistration.noResult
        }
        
        emptyDescriptionLabel.do {
            $0.text = "검색 결과가 없어요ㅠ"
            $0.font = .Body1
            $0.textColor = .Gray200
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(emptyImageView,
                         emptyDescriptionLabel)
        
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(191)
            $0.centerX.equalToSuperview()
        }
        
        emptyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(9)
            $0.centerX.equalToSuperview()
        }
    }
}
