//
//  ViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 1/1/24.
//

import UIKit

import SnapKit

class ViewController: UIViewController {
    
    private var mainButton = WSSMainButton(title: "안녕 얘두라?")
     
     override func viewDidLoad() {
         super.viewDidLoad()
         self.view.backgroundColor = .white
         self.view.addSubview(mainButton)
     }
}

