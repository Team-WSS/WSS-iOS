//
//  RegisterNormalViewController.swift
//  WSSiOS
//
//  Created by 이윤학 on 1/6/24.
//

import UIKit

import Then
import SnapKit

/// 1-3-1 RegisterNormal View
final class RegisterNormalViewController: ViewController {
    
    // MARK: - Properties
    
    private let rootView = RegisterNormalView()
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHieararchy()
        setUI()
        setLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - @Functions
    
    private func setUI() {
        
    }
    
    private func setLayout() {
        
    }
    
    func setHieararchy() {
        
    }
}
