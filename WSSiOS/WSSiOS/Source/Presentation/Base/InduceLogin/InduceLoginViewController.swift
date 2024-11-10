//
//  InduceLoginViewController.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 11/10/24.
//

import UIKit

final class InduceLoginViewController: UIViewController {
    
    //MARK: - Properties
    
    
    //MARK: - UI Components
    
    private let rootView = InduceLoginView()
    
    //MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setUI() {
        self.view.backgroundColor = .wssWhite
    }
    
    //MARK: - Bind
    
}
