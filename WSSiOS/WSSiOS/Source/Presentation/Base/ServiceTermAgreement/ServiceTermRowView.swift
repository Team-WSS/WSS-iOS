//
//  ServiceTermRowView.swift
//  WSSiOS
//
//  Created by YunhakLee on 2/11/25.
//

import UIKit

import SnapKit
import Then


final class ServiceTermRowView: UIView {
    
    //MARK: - Prooerties
    
    let serviceTerm: ServiceTerm
    
    //MARK: - Components
    
    let termLabel = UILabel()
    let termAgreeButton = UIButton()
    
    
    // MARK: - Life Cycle
    
    init(_ serviceTerm: ServiceTerm) {
        self.serviceTerm = serviceTerm
        
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
        
        bindData(serviceTerm)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        termAgreeButton.do {
            $0.setImage(.icSelectNovelDefault, for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(termLabel,
                         termAgreeButton)
    }
    
    private func setLayout() {
        termLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        termAgreeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(24)
        }
    }
    
    //MARK: - Custom Method
    
    private func bindData(_ serviceTerm: ServiceTerm) {
        termLabel.do {
            $0.font = .Body2
            $0.makeAttribute(with: serviceTerm.fullText)?
                .lineHeight(WSSFont.body2.lineHeightMultiple)
                .kerning(kerningPixel: WSSFont.body2.kerningPixel)
                .partialUnderlineStyle(.single, rangeString: serviceTerm.underlineText)
                .applyAttribute()
        }
    }
    
    func updateAgreeButton(isAgree: Bool) {
        termAgreeButton.setImage(isAgree ? .icSelectNovelSelected : .icSelectNovelDefault,
                                 for: .normal)
    }
}
