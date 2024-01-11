//
//  HomeCharacterView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class HomeCharacterView: UIView {
    
    //MARK: - UI Components
    
    let characterStackView = UIStackView()
    let tagView = HomeCharacterTagView()
    let characterCommentLabel = UILabel()
    let characterImageView = UIImageView()
    
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
        characterStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.setCustomSpacing(10, after: tagView)
            $0.setCustomSpacing(12, after: characterCommentLabel)
        }
        
        characterCommentLabel.do {
            $0.text = "지원 영애, 오랜만입니다"
            $0.font = .Title1
            $0.textColor = .Black
        }
        
        characterImageView.do {
            $0.image = UIImage(named: "render")
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        characterStackView.addArrangedSubviews(tagView,
                                               characterCommentLabel,
                                               characterImageView)
        self.addSubviews(characterStackView)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        characterStackView.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
        }
        
        characterStackView.do {
            $0.setCustomSpacing(10, after: tagView)
            $0.setCustomSpacing(12, after: characterCommentLabel)
        }
    }
}
