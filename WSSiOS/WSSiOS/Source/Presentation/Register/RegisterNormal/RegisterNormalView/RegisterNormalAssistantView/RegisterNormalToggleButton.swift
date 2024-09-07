//
//  RegisterNormalToggleButton.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class RegisterNormalToggleButton: UIButton {
    
    //MARK: - Properties
    
    // 상태별 스위치 배경 색상
    let onColor = UIColor.wssPrimary100
    let offColor = UIColor.wssGray70
    
    // 스위치가 이동하는 애니메이션 시간
    var animationDuration: TimeInterval = 0.20
    
    // 각 View의 Size
    typealias SizeSet = (height: CGFloat, width: CGFloat)
    
    private var toggleSize: SizeSet = (height: 32, width: 32)
    private var barViewSize: SizeSet = (height: 16.55, width: 30.9)
    private var circleViewSize: SizeSet = (height: 11.03, width: 11.03)
    
    //MARK: - Components
    
    var barView = UIView()
    var circleView = UIView()
    
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
        barView.do {
            $0.backgroundColor = onColor
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = barViewSize.height / 2
            $0.isUserInteractionEnabled = false  // superView인 버튼만 터치되도록
        }
        
        circleView.do {
            $0.backgroundColor = .wssWhite
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = circleViewSize.height / 2
            $0.isUserInteractionEnabled = false  // superView인 버튼만 터치되도록
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(barView,
                         circleView)
    }
    
    private func setLayout() {
        self.snp.makeConstraints() {
            $0.size.equalTo(toggleSize.height)
        }
        
        barView.snp.makeConstraints {
            $0.width.equalTo(barViewSize.width)
            $0.height.equalTo(barViewSize.height)
            $0.center.equalToSuperview()
        }
        
        circleView.snp.makeConstraints {
            $0.width.equalTo(circleViewSize.width)
            $0.height.equalTo(circleViewSize.height)
            $0.trailing.equalTo(barView.snp.trailing).inset(2.76)
            $0.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Custom Method
    
    func updateToggle(_ state: Bool) {
        UIView.animate(withDuration: self.animationDuration) {
            if state {
                self.onStateLayout()
                self.barView.backgroundColor = self.onColor
            } else {
                self.offStateLayout()
                self.barView.backgroundColor = self.offColor
            }
            self.layoutIfNeeded()
        }
    }
    
    func onStateLayout() {
        circleView.snp.updateConstraints {
            $0.trailing.equalTo(barView.snp.trailing).inset(2.76)
        }
    }
    
    func offStateLayout() {
        circleView.snp.updateConstraints {
            $0.trailing.equalTo(barView.snp.trailing).inset(17.1)
        }
    }
}
