//
//  KeywordLink.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/13/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class KeywordLink: UIView {
    
    //MARK: - Properties
    
    private var labelHeight: CGFloat = 35
    
    //MARK: - Components
    
    private let keywordLabel = UILabel()
    
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
            $0.backgroundColor = .wssGray50
            $0.layer.borderColor = UIColor.wssPrimary100.cgColor
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(keywordLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(labelHeight)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(13)
            $0.centerY.equalToSuperview()
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
            $0.textColor = .wssGray300
        }
    }
    
    func updateColor(_ isSelected: Bool) {
        keywordLabel.textColor = isSelected ? .wssPrimary100 : .wssGray300
        self.backgroundColor = isSelected ? .wssPrimary50 : .wssGray50
        self.layer.borderWidth = isSelected ? 1 : 0
    }
}
