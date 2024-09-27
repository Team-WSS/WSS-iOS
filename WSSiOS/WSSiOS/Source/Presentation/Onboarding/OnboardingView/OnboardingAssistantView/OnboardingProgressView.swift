//
//  OnboardingProgressBarView.swift
//  WSSiOS
//
//  Created by YunhakLee on 9/27/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingProgressView: UIView {
    
    //MARK: - Properties
    
    let animationDuration = 0.20
    
    //MARK: - Components
    
    private let backgroundView = UIView()
    private let progressView = UIView()
    
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
        backgroundView.do {
            $0.backgroundColor = .wssGray70
           
        }
        
        progressView.do {
            $0.backgroundColor = .wssPrimary100
        }
    }
    
    private func setHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(progressView)
    }
    
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(4)
        }
       
        progressView.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(UIScreen.main.bounds.width/3*2)
        }
    }
    
    //MARK: - Data
    
    func updateProgressView(_ stage: Int) {
        let trailingInset = UIScreen.main.bounds.width/3*CGFloat(2 - stage)
        
        UIView.animate(withDuration: self.animationDuration) {
            self.progressView.snp.updateConstraints {
                $0.verticalEdges.leading.equalToSuperview()
                $0.trailing.equalToSuperview().inset(trailingInset)
            }
            
            self.superview?.layoutIfNeeded()
        }
    }
}
