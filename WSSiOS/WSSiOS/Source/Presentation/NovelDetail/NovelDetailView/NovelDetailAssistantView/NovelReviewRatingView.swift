//
//  NovelReviewRatingView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import SnapKit
import Then

final class NovelReviewRatingView: UIView {
    
    //MARK: - Components
    
    let starImageStackView = UIStackView()
    lazy var starImageViews: [UIImageView] = createStars()
    
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
            $0.backgroundColor = .white
        }
        
        starImageStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
        }
    }
    
    private func setHierarchy() {
        self.addSubview(starImageStackView)
        starImageViews.forEach {
            starImageStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        starImageStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(34)
            $0.width.equalTo(190)
            $0.height.equalTo(30)
        }
        
        starImageViews.forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(30)
            }
        }
    }
    
    //MARK: - Custom Method
    
    private func createStars() -> [UIImageView] {
        return (0..<5).map { _ in
            let starImageView = UIImageView().then {
                $0.isUserInteractionEnabled = true
                $0.image = .icStarEmpty
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
            }
            return starImageView
        }
    }
}
