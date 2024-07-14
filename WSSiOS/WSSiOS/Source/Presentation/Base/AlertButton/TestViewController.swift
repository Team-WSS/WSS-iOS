//
//  TestViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 7/14/24.
//

import UIKit

import RxSwift
import RxCocoa

final class TestViewController: UIViewController {
    
    //MARK: - UI Components
    
    var rootView = WSSAlertButtonView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
}

