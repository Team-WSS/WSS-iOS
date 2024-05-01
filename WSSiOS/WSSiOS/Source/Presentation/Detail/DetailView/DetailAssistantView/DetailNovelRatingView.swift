//
//  DetailNovelRatingView.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/29/24.
//

import UIKit

import SnapKit
import Then

final class DetailNovelRatingView: UIView {
    
    //MARK: - Components
    
    private let starRatingStackView = UIStackView()
    private lazy var starImageViews: [UIImageView] = createStars()
    
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
        
    }
    
    private func setHierarchy() {
        self.addSubview(starRatingStackView)
        
        starImageViews.forEach {
            starRatingStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        starImageViews.forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(31)
                $0.height.equalTo(31)
            }
        }
    }
    
    //MARK: - Data
    
    func bindData(_ data: DetailBasicResult) {
        
    }
    
    //MARK: - Custom Method
    
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
