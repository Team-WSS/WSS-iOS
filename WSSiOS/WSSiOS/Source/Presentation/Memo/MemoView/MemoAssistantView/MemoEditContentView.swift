//
//  MemoEditContentView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/13/24.
//

import UIKit

import SnapKit
import Then

final class MemoEditContentView: UIView {

    //MARK: - Components
    
    let memoTextView = UITextView()
    
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
        self.backgroundColor = .wssGray50
        
        memoTextView.do {
            $0.backgroundColor = .clear
            $0.textColor = .wssBlack
            $0.font = .Body1
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private func setHierarchy() {
        self.addSubview(memoTextView)
    }
    
    private func setLayout() {
        memoTextView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
    
    func updateTextViewConstraint(keyboardHeight: CGFloat) {
        self.memoTextView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight + 20)
        }
    }
    
    func bindData(memoContent: String) {
        self.memoTextView.do {
            $0.makeAttribute(with: memoContent)?
                .lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -0.8)
                .applyAttribute()
            $0.font = .Body1
        }
    }
}
