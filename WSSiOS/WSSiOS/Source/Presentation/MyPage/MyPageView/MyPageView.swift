//
//  MyPageView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

class MyPageView: UIView {

    //MARK: - UI Components
    
    private var myPageStackView = UIStackView()
    private var myPageProfileView = MyPageProfileView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        self.backgroundColor = .White
        
        myPageStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
    }
    
    private func setHierachy() {
        self.addSubviews(myPageStackView)
        myPageStackView.addArrangedSubviews(myPageProfileView)
    }
    
    private func setLayout() {
        myPageStackView.snp.makeConstraints() {
            $0.top.width.bottom.equalToSuperview()
        }
    }
    
}
