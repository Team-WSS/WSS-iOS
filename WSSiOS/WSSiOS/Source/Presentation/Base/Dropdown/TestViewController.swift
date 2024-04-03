//
//  TestViewController.swift
//  WSSiOS
//
//  Created by 신지원 on 4/3/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class TestViewController: UIViewController {
    
    private var rootView = TestView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
