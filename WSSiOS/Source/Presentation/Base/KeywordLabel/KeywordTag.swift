//
//  KeywordTag.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/13/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class KeywordTag: UIView {
    
    //MARK: - Properties
    
    private var labelHeight: CGFloat = 35
    
    //MARK: - Components
    
    private let contentStackView = UIStackView()
    private let keywordLabel = UILabel()
    private let eraseButton = UIButton()
    lazy var tapEvent = eraseButton.rx.tap
    
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
            $0.layer.cornerRadius = labelHeight / 2
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.wssPrimary100.cgColor
        }
        
        contentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
            
            eraseButton.do {
                $0.setImage(.icKeywordCancel, for: .normal)
                $0.isUserInteractionEnabled = false
            }
        }
        
        keywordLabel.do {
            $0.textColor = .wssPrimary100
        }
    }
    
    private func setHierarchy() {
        self.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(keywordLabel,
                                             eraseButton)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(labelHeight)
        }
        
        contentStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(13)
            $0.centerY.equalToSuperview()
        }
        
        eraseButton.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    
    //MARK: - Custom Method
    
    func setText(_ text: String) {
        keywordLabel.do {
            $0.applyWSSFont(.body2, with: text)
        }
    }
    
    func setBackgroundColor(_ color: UIColor) {
        self.do {
            $0.backgroundColor = color
        }
    }
}
