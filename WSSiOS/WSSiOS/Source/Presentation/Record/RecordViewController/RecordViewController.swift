//
//  RecordViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

final class RecordViewController: UIViewController {
    
    private let rootView = RecordResultView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        self.view.do {
            $0.backgroundColor = .White
        }
    }
}
