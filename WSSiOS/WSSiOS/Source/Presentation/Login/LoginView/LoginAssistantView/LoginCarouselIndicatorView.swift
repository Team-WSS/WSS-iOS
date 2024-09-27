//
//  LoginCarouselIndicatorView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/18/24.
//

import UIKit

import SnapKit
import Then

final class LoginCarouselIndicatorView: UIView {
    
    //MARK: - Components
    
    private let dotStackView = UIStackView()
    let dotViews: [LoginCarouselIndicatorDotView] = (0...3).map{
        LoginCarouselIndicatorDotView(index: $0)
    }
    
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
        dotStackView.do {
            $0.axis = .horizontal
            $0.spacing = 7.23
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(dotStackView)
        dotViews.forEach{ view in
            dotStackView.addArrangedSubview(view)
        }
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(7.23)
        }
        
        dotStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(7.23)
        }
    }
    
    func updateUI(selectedIndex: Int) {
        dotViews.forEach {
            $0.updateUI(selectedIndex: selectedIndex)
        }
    }
}
