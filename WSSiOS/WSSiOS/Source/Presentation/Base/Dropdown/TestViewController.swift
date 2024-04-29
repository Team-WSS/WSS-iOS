//
//  TestViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 4/29/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class TestViewController: UIViewController {
    
    private let dummyData = ["수정하기", "삭제하기"]
    private let dropdownView = WSSDropdown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    private func setUI() {
        dropdownView.makeDropdown(dropdownRootView: self.view,
                                  dropdownWidth: 190,
                                  dropdownData: dummyData,
                                  textColor: .wssBlack)
    }
    
    private func setHierarchy() {
        self.view.addSubview(dropdownView)
    }
    
    private func setLayout() {
        dropdownView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.size.equalTo(38)
        }
    }
}
