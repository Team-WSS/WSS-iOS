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
    let termLabelButton = UIButton()
    let termAgreeButton = UIButton()
    
    
    // MARK: - Life Cycle
    
    init(_ serviceTerm: ServiceTerm) {
        self.serviceTerm = serviceTerm
        
        super.init(frame: .zero)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func setUI() {
        termLabel.do {
            $0.font = .Body2
            $0.textColor = .wssGray200
            $0.makeAttribute(with: serviceTerm.fullText)?
                .lineHeight(WSSFont.body2.lineHeightMultiple)
                .kerning(kerningPixel: WSSFont.body2.kerningPixel)
                .partialUnderlineStyle(.single, rangeString: serviceTerm.underlineText)
                .applyAttribute()
            $0.isUserInteractionEnabled = false
        }
        
        termAgreeButton.do {
            $0.setImage(.icSelectNovelDefault2.withRenderingMode(.alwaysOriginal), for: .normal)
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = .blue
            $0.configuration = config
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(termLabelButton,
                         termAgreeButton)
        termLabelButton.addSubview(termLabel)
    }
    
    private func setLayout() {
        termLabelButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        termLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        termAgreeButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(56)
            $0.trailing.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    //MARK: - Custom Method
    
    func updateAgreeButton(isAgreed: Bool) {
        termAgreeButton.setImage(isAgreed ? .icSelectNovelSelected : .icSelectNovelDefault2,
                                 for: .normal)
    }
}
