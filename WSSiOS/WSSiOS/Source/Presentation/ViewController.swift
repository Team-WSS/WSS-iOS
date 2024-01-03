//
//  ViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/1/24.
//

import UIKit

import SnapKit

class ViewController: UIViewController {

    var testLabel: UILabel = {
        let label = UILabel()
        label.text = "Test 입니다."
        label.font = .Label1
        label.textColor = .Gray300
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .GrayToast
        self.view.addSubview(testLabel)
        
        testLabel.snp.makeConstraints() {
            $0.centerX.centerY.equalToSuperview()
        }
    }


}

