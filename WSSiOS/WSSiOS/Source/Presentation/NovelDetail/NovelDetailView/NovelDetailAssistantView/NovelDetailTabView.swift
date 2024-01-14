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
    
    //MARK: - set Properties

    private let screenWidth = UIScreen.main.bounds.size.width

    // MARK: - UI Components
    
    public let memoButton = UIButton()
    public let infoButton = UIButton()
    private let dividerView = UIView()
    public let highlightView = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - set UI
    
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
    
    // MARK: - set Hierachy
    
    private func setHierachy() {
        self.addSubviews(memoButton, 
                         infoButton,
                         dividerView,
                         highlightView)
    }
    
    // MARK: - set Layout
    
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
