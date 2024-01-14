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
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let lottieView = LottieAnimationView(name: "animationRegistration")
    private var makeMemoButton = WSSMainButton(title: "작품에 메모 남기기")
    private var returnHomeButton = UIButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHieararchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        titleLabel.do {
            $0.text = "내 서재에 작품이\n성공적으로 등록되었어요!"
            $0.makeAttribute()?.lineSpacing(spacingPercentage: 140)
                .kerning(kerningPixel: -1.2).applyAttribute()
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.textColor = .Black
            $0.font = .HeadLine1
        }
            
        lottieView.do {
            $0.play()
        }
        
        returnHomeButton.do {
            $0.setTitle("홈으로 돌아가기", for: .normal)
            $0.setAttributedTitle($0.titleLabel?.makeAttribute()?
                                                .kerning(kerningPixel: -0.6)
                                                .lineSpacing(spacingPercentage: 150)
                                                .attributedString,
                                  for: .normal)
            $0.setTitleColor(.Gray300, for: .normal)
            $0.titleLabel?.font = .Body2
        }
    }
    
    private func setHieararchy() {
        self.addSubviews(titleLabel, lottieView, makeMemoButton, returnHomeButton)
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
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(14)
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
        }
    }
}

