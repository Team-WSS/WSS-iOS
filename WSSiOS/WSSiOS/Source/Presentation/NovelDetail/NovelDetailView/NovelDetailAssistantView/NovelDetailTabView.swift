//
//  NovelDetailTabView.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class NovelDetailTabView: UIView {
    
    // MARK: - Properties

    private let screenWidth = UIScreen.main.bounds.size.width

    // MARK: - Components

    public let memoButton = UIButton()
    public let infoButton = UIButton()
    private let dividerView = UIView()
    public let highlightView = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    
    private func setUI() {
        memoButton.do {
            $0.isSelected = true
            $0.setTitle("메모", for: .normal)
            $0.titleLabel?.font = .Title2
            $0.setTitleColor(.Gray200, for: .normal)
            $0.setTitleColor(.Black, for: .selected)
            $0.backgroundColor = .White
        }
        
        infoButton.do {
            $0.isSelected = false
            $0.setTitle("정보", for: .normal)
            $0.titleLabel?.font = .Title2
            $0.setTitleColor(.Gray200, for: .normal)
            $0.setTitleColor(.Black, for: .selected)
            $0.backgroundColor = .White
        }
        
        dividerView.do {
            $0.backgroundColor = .Gray70
        }
        
        highlightView.do {
            $0.backgroundColor = .Black
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(memoButton,
                         infoButton,
                         dividerView,
                         highlightView)
    }
    
    private func setLayout() {
        memoButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(screenWidth / 2)
            $0.height.equalTo(46)
        }
        
        infoButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.equalTo(screenWidth / 2)
            $0.height.equalTo(46)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(memoButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().inset(1)
        }
        
        highlightView.snp.makeConstraints {
            $0.top.equalTo(memoButton.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalTo(screenWidth / 2)
            $0.height.equalTo(2)
        }
    }
    
    // MARK: - Custom Method
    
    func highlightMemoButton() {
        highlightView.snp.remakeConstraints {
            $0.top.equalTo(memoButton.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalTo(screenWidth / 2)
            $0.height.equalTo(2)
        }
    }
    
    func highlightInfoButton() {
        highlightView.snp.remakeConstraints {
            $0.top.equalTo(memoButton.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(screenWidth / 2)
            $0.height.equalTo(2)
        }
    }
}
