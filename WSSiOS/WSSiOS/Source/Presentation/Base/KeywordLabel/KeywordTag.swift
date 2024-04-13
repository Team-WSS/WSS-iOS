//
//  KeywordLabelwithX.swift
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
    
    private let ContentStackView = UIStackView()
    private let keywordLabel = UILabel()
    private let eraseButton = UIButton()
    lazy var tapEvent = eraseButton.rx.tap
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setText("키워드")
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
        
        ContentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
            
            eraseButton.do {
                $0.setImage(.icKeywordCancel, for: .normal)
            }
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(ContentStackView)
        ContentStackView.addArrangedSubviews(keywordLabel,
                                             eraseButton)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(labelHeight)
        }
        
        ContentStackView.snp.makeConstraints {
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
            $0.makeAttribute(with: text)?
                .lineSpacing(spacingPercentage: 150)
                .kerning(kerningPixel: -0.6)
                .applyAttribute()
            $0.font = .Body2
            $0.textColor = .wssPrimary100
        }
    }
}
