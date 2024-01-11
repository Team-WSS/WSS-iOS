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
        
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .center
            $0.setCustomSpacing(8, after: registerPlusImageView)
            $0.setCustomSpacing(45, after: recordEmptyDescriptionLabel)
        }
        
        registerPlusImageView.do {
            $0.image = ImageLiterals.icon.icBookRegistration.plus
        }
        
        recordEmptyDescriptionLabel.do {
            $0.text = "읽은 웹소설에 대해\n기록을 남겨볼까요?"
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.font = .Body1
            $0.textColor = .Gray200
        }
        
        recordButton.do {
            $0.backgroundColor = .Primary50
            $0.layer.cornerRadius = 12
            $0.setTitle("웹소설 등록하기", for: .normal)
            $0.setTitleColor(.Primary100, for: .normal)
            $0.titleLabel?.font = .Title1
            $0.contentEdgeInsets = UIEdgeInsets(top: 18, left: 42, bottom: 18, right: 42)
        }
    }
    
    private func setHierachy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubviews(registerPlusImageView,
                                      recordEmptyDescriptionLabel,
                                      recordButton)
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(158)
            $0.centerX.equalToSuperview()
        }
    }
}
