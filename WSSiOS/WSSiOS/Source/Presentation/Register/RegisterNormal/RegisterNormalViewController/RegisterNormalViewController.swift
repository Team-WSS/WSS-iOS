//
//  RegisterNormalViewController.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/6/24.
//

import UIKit

/// 1-3-1 RegisterNormal View
final class RegisterNormalViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = RegisterNormalView()
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
