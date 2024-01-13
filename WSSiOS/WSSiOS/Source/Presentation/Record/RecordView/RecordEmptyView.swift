//
//  RecordEmptyView.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

import SnapKit
import Then

final class RecordEmptyView: UIView {
    
    //MARK: - UI Components
    
    private let dividerView = UIView()
    private let stackView = UIStackView()
    private let registerPlusImageView = UIImageView()
    private let recordEmptyDescriptionLabel = UILabel()
    private let recordButton = UIButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierachy()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.do {
            $0.backgroundColor = .White
        }
        
        dividerView.do {
            $0.backgroundColor = .Gray50
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.setCustomSpacing(8, after: registerPlusImageView)
            $0.setCustomSpacing(45, after: recordEmptyDescriptionLabel)
        }
        
        registerPlusImageView.do {
            $0.image = ImageLiterals.icon.BookRegistration.plus
        }
        
        recordEmptyDescriptionLabel.do {
            $0.text = "읽은 웹소설에 대해\n기록을 남겨볼까요?"
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.font = .Body1
            $0.textColor = .Gray200
        }
        
        recordButton.do {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .Primary50
            config.baseForegroundColor = .Primary100
            var titleAttr = AttributedString.init("웹소설 등록하기")
            titleAttr.font = UIFont.Title1
            
            config.attributedTitle = titleAttr
            config.background.cornerRadius = 12
            config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 42, bottom: 18, trailing: 42)
            $0.configuration = config
        }
    }
    
    private func setHierachy() {
        self.addSubviews(dividerView,
                         stackView)
        
        stackView.addArrangedSubviews(registerPlusImageView,
                                      recordEmptyDescriptionLabel,
                                      recordButton)
    }
    
    private func setLayout() {
        dividerView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(158)
            $0.centerX.equalToSuperview()
        }
    }
}
