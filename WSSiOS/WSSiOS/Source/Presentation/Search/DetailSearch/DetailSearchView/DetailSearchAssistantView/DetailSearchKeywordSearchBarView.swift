//
//  DetailSearchKeywordSearchBarView.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/21/24.
//

import UIKit

import SnapKit
import Then

final class DetailSearchKeywordSearchBarView: UIView {
    
    //MARK: - UI Components

    private let searchTextField = UITextField()
    private let searchClearButton = UIButton()
    private let searchImageView = UIImageView()
    
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
        
        self.do {
            $0.backgroundColor = .wssGray50
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }
        
        searchTextField.do {
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.textColor = .wssBlack
            $0.font = .Label1
            $0.rightView = searchClearButton
            $0.rightViewMode = .whileEditing
            $0.placeholder = StringLiterals.DetailSearch.placeHolder
        }
        
        searchClearButton.do {
            $0.setImage(.icSearchCancel, for: .normal)
        }
        
        searchImageView.do {
            $0.image = .icSearch
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.wssGray300)
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(searchTextField,
                         searchImageView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(42)
        }

        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        searchImageView.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchTextField.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
}
