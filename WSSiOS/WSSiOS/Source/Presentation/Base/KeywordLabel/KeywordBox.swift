//
//  KeywordBox.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 7/18/24.
//

import UIKit

import SnapKit
import Then

final class KeywordBox: UIView {
    
    //MARK: - Properties
    
    private var boxWidth: CGFloat =. 62
    private var boxHeight: CGFloat = 43
    
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
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .wssGray50
            $0.layer.borderColor = UIColor.wssPrimary100.cgColor
        }
    }
    
    private func setHierarchy() {
        self.addSubview(keywordLabel)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(boxWidth)
            $0.height.equalTo(boxHeight)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func setText(_ text: String) {
        keywordLabel.do {
            $0.applyWSSFont(.body2, with: text)
            $0.textColor = .wssGray300
        }
    }
    
    func updateColor(_ isSelected: Bool) {
        keywordLabel.textColor = isSelected ? .wssPrimary100 : .wssGray300
        self.backgroundColor = isSelected ? .wssPrimary50 : .wssGray50
        self.layer.borderWidth = isSelected ? 1 : 0
    }
}
