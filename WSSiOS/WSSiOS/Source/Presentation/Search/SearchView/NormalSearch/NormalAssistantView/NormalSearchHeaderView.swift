//
//  NormalSearchHeaderView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/27/24.
//

import UIKit

import SnapKit
import Then

final class NormalSearchHeaderView: UIView {
    
    //MARK: - Components
    
    let backButton = UIButton()
    private let searchBar = UISearchBar()
    
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
    
    //MARK: - UI
    
    private func setUI() {
        backButton.do {
            $0.setImage(.icNavigateLeft, for: .normal)
        }
        
        searchBar.do {
            $0.setImage(.icSearchCancel, for: .clear, state: .normal)
            $0.layer.borderColor = UIColor.wssGray70.cgColor
            $0.layer.borderWidth = 1
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 14
        }
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = .clear
            textfield.font = .Label1
            textfield.textColor = .wssBlack
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(backButton,
                         searchBar)
    }
    
    private func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.equalTo(backButton.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(13)
        }
    }
}
