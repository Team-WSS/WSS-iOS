//
//  MyPageChangeUserInfoView.swift
//  WSSiOS
//
//  Created by 신지원 on 9/20/24.
//

import Foundation

final class MyPageChangeUserInfoView: UIView {

    //MARK: - Components
    
    //In VC
    let backButton = UIButton()
    let completeButton = UIButton()

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
        self.do {
            $0.backgroundColor = .wssWhite
        }

       
    }

    private func setHierarchy() {
        self.addSubview()
    }

    private func setLayout() {
        backButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }

        completeButton.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(42)
        }
    }

    //MARK: - Data

}
