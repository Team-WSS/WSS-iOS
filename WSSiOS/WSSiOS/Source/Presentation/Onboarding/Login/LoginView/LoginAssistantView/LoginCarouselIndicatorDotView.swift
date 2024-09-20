//
//  LoginCarouselIndicatorDotView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/17/24.
//

import UIKit

import SnapKit
import Then

final class LoginCarouselIndicatorDotView: UIView {
    
    //MARK: - Properties
    
    private let index: Int
    
    private let animationDuration = 0.20
    private let height = 7.23
    private let basicWidth = 7.23
    private let selectedWidth = 17.16
   
    //MARK: - Life Cycle
    
    init(index: Int) {
        self.index = index
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        self.do {
            $0.layer.cornerRadius = height / 2
            $0.backgroundColor = .wssGray100
        }
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(height)
            $0.width.equalTo(basicWidth)
        }
    }
    
    //MARK: - Data
    
    func updateUI(selectedIndex: Int) {
        let isSelected = selectedIndex == index
        
        // layoutIfNeeded()를 애니메이션 블록 밖으로 이동
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: self.animationDuration) {
            self.snp.updateConstraints {
                $0.width.equalTo(isSelected ? self.selectedWidth : self.basicWidth)
            }
            self.backgroundColor = isSelected ? .wssPrimary100 : .wssGray100
            
            // 애니메이션 블록 내부에서 layoutIfNeeded() 호출
            self.superview?.layoutIfNeeded()
        }
    }
}
