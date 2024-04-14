//
//  HomeTodayPopularView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 4/14/24.
//

import UIKit

final class HomeTodayPopularView: UIView {
    
    private let titleLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .Gray70
        
        titleLabel.do {
            $0.font = .HeadLine1
            $0.textColor = .wssBlack
            $0.makeAttribute(with: StringLiterals.Home.Title.todayPopular)?
            .kerning(kerningPixel: -1.2)
            .applyAttribute()
        }
    }
    
    private func setHierarchy() {
        self.addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
