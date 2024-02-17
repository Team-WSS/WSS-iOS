//
//  RegisterSuccessView.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/13/24.
//

import UIKit

import Lottie
import SnapKit
import Then

final class RegisterSuccessView: UIView {
    
    //MARK: - Components
    
    private let titleLabel = UILabel()
    private let lottieView = LottieLiterals.Register.success
    let makeMemoButton = WSSMainButton(title: StringLiterals.Register.Success.makeMemo)
    let returnHomeButton = UIButton()
    
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
        self.do{
            $0.backgroundColor = .wssWhite
        }
        
        titleLabel.do {
            $0.text = StringLiterals.Register.Success.title
            $0.makeAttribute()?.lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -1.2).applyAttribute()
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.textColor = .wssBlack
            $0.font = .HeadLine1
        }
            
        lottieView.do {
            $0.play()
        }
        
        returnHomeButton.do {
            $0.setTitle(StringLiterals.Register.Success.returnHome,
                        for: .normal)
            $0.setAttributedTitle($0.titleLabel?.makeAttribute()?
                                                .kerning(kerningPixel: -0.6)
                                                .lineSpacing(spacingPercentage: 150)
                                                .attributedString,
                                  for: .normal)
            $0.setTitleColor(.Gray300,
                             for: .normal)
            $0.titleLabel?.font = .Body2
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         lottieView,
                         makeMemoButton,
                         returnHomeButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(lottieView.snp.top).offset(-36)
        }
        
        lottieView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(lottieView.snp.width)
            $0.centerY.equalToSuperview()
        }
        
        makeMemoButton.snp.makeConstraints {
            $0.bottom.equalTo(returnHomeButton.snp.top)
        }
        
        returnHomeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-14)
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
        }
    }
}

