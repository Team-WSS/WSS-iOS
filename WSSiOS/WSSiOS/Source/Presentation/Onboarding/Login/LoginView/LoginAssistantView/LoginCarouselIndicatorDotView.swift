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
        
        self.do {
            $0.backgroundColor = isSelected ? .wssPrimary100 : .wssGray100
            
            $0.snp.updateConstraints {
                $0.width.equalTo(isSelected ? selectedWidth : basicWidth )
            }
        }
    }
}
