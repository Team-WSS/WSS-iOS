//
//  HomeSosoPickTitleView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class HomeSosoPickTitleView: UIView {
    
    //MARK: - UI Components
    
    private let titleStackView = UIStackView()
    private let circleImageView = UIImageView()
    private let sosopickTitleLabel = UILabel()
    private let sosopickDescriptionLabel = UILabel()
    
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
        titleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 9
        }
        
        circleImageView.do {
            $0.image = .sosopickCircle
            $0.contentMode = .scaleAspectFit
        }
        
        sosopickTitleLabel.do {
            $0.makeAttribute(with: "소소’s pick")?
                .kerning(kerningPixel: -1.2)
                .applyAttribute()
            $0.font = .HeadLine1
            $0.textColor = .Black
        }
        
        sosopickDescriptionLabel.do {
            $0.makeAttribute(with: "지금 소소들이 등록한 작품")?
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
            $0.textColor = .Gray200
        }
    }
    
    //MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubview(titleStackView)
        titleStackView.addArrangedSubviews(circleImageView,
                                           sosopickTitleLabel,
                                           sosopickDescriptionLabel)
    }
    
    //MARK: - set Layout
    
    private func setLayout() {
        titleStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
