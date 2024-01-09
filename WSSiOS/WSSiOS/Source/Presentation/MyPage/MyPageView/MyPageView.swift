//
//  MyPageView.swift
//  WSSiOS
//
//  Created by 신지원 on 1/8/24.
//

import UIKit

class MyPageView: UIView {

    //MARK: - UI Components
    
    private let myPageProfileView = MyPageProfileView()
    
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
    }
    
    private func setHierachy() {
        self.addSubviews(myPageProfileView)
    }
    
    private func setLayout() {
        myPageProfileView.snp.makeConstraints() {
            $0.top.equalTo(super.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
        }
    }
    
}
