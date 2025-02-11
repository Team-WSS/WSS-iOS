//
//  ServiceTermAgreementView.swift
//  WSSiOS
//
//  Created by YunhakLee on 2/11/25.
//

import UIKit

import SnapKit
import Then


final class ServiceTermAgreementView: UIView {
    
    //MARK: - Components
    
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let agreeAllButton = UIButton()
    private let agreeAllButtonLabel = UILabel()
    private let agreeAllButtonImageView = UIImageView()
    
    private let firstTermLabel = UILabel()
    private let firstTermAgreeButton = UIButton()
    
    private let secondTermLabel = UILabel()
    private let secondTermAgreeButton = UIButton()
    
    private let 
    
  
    // MARK: - Life Cycle
    
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
      
    }
    
    private func setHierarchy() {
       
    }
    
    private func setLayout() {
       
    }
    
    //MARK: - Custom Method
    
    private func applyFontWithPartialUnderLine(label: UILabel, text: String, underlinePart: String) {
        label.do {
            $0.font = .Body2
            $0.makeAttribute(with: text)?
                .lineHeight(WSSFont.body2.lineHeightMultiple)
                .kerning(kerningPixel: WSSFont.body2.kerningPixel)
                .partialUnderlineStyle(.single, rangeString: underlinePart)
                .applyAttribute()
        }
    }
}
