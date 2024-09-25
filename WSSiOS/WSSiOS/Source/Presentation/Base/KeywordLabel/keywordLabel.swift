//
//  KeywordLabel.swift
//  WSSiOS
//
//  Created by 이윤학 on 4/13/24.
//

import UIKit

import SnapKit
import Then

final class KeywordLabel: UIView {
    
    //MARK: - Properties
    
    private var labelHeight: CGFloat = 35
    
    //MARK: - Components
    
    private let keywordLabel = UILabel()
    
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
            $0.backgroundColor = .wssPrimary50
        }
    }
    
    private func setHierarchy() {
        self.addSubview(keywordLabel)
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
            $0.applyWSSFont(.body2,
                            with: text)
            $0.textColor = .wssPrimary100
        }
    }
}
