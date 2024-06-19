//
//  NovelDetailNovelRatingView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/29/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailHeaderRatingButton: UIButton {
    
    //MARK: - Components
    
    private let stackView = UIStackView()
    private let dummyLabel = UILabel()
    
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
        self.do {
            $0.backgroundColor = .wssWhite
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.layer.borderWidth = 1
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.alignment =  .center
        }
        
        dummyLabel.do {
            $0.applyWSSFont(.headline1, with: "디자인 미정")
            $0.textColor = .wssGray80
        }
    }
    
    private func setHierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(dummyLabel)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(15)
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: NovelDetailBasicResult) {
        
    }
    
    //MARK: - Custom Method
    
    // 별점으로 디자인이 유지되면 사용예정인 메서드
    private func createStars() -> [UIImageView] {
        return (0..<5).map { _ in
            let starImageView = UIImageView().then {
                $0.isUserInteractionEnabled = true
                $0.image = .icStarEmpty
                $0.contentMode = .scaleToFill
                $0.clipsToBounds = true
            }
            return starImageView
        }
    }
}
