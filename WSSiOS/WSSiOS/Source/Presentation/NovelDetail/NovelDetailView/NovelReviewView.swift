//
//  NovelReviewView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 8/28/24.
//

import UIKit

import SnapKit
import Then

final class NovelReviewView: UIView {

    //MARK: - Components
    
    let backButton = UIButton()
    let completeButton = UIButton()
    
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
        }
        
        backButton.do {
            $0.setImage(.icNavigateLeft.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .wssGray200
        }
        
        completeButton.do {
            $0.setButtonAttributedTitle(text: StringLiterals.NovelReview.Navigation.complete, font: .Title2, color: .wssGray200)
            $0.isEnabled = false
        }
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
    
    //MARK: - Custom Method
    
    func enableCompleteButton(isEnabled: Bool) {
        completeButton.do {
            $0.setButtonAttributedTitle(text: StringLiterals.NovelReview.Navigation.complete, font: .Title2, color: isEnabled ? .wssPrimary100 : .wssGray200)
            $0.isEnabled = isEnabled
        }
    }
}
