//
//  RecordViewController.swift
//  WSSiOS
//
//  Created by 최서연 on 1/12/24.
//

import UIKit

final class RecordViewController: UIViewController {
    
    private let rootView = RecordEmptyView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .White
    }
}
